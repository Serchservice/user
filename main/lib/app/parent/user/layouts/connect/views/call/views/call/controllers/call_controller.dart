import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:connectify_flutter/connectify_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;
import 'package:user/library.dart';

class CallController extends GetxController {
  CallController();
  final state = CallState();
  final args = Get.arguments;

  final ConnectService _connect = Connect();

  final TextEditingController amount = TextEditingController();

  late stream.Call streamCall;
  StreamSubscription<dynamic>? streamSubscription;
  StreamSubscription<List<stream.RtcMediaDevice>>? _deviceChangeSubscription;
  stream.RtcMediaDeviceNotifier? _deviceNotifier;
  var _audioOutputs = <stream.RtcMediaDevice>[];

  final AudioPlayer _player = AudioPlayer();

  DateTime? _startedAt;
  Duration _duration = Duration.zero;
  Timer? _timer;

  @override
  void onInit() {
    state.call.value = ActiveCallResponse.fromJson(args["call"]);

    if(args["search"] != null) {
      state.search.value = RequestSearch.fromJson(args["search"]);
    }

    super.onInit();
  }

  @override
  void onReady() {
    if(state.call.value.start) {
      _createCall();
    }

    if(state.call.value.answer) {
      _answerCall();
    }

    if(args["stream"] != null) {
      streamCall = args["stream"];
      state.isInitialized.value = true;
      _eventListener();
      _addDeviceSubscription();
    }

    amount.addListener(() {
      if(amount.text.trim().isNotEmpty) {
        state.amount.value = amount.text.trim();
      }
    });

    _updateCall(state.call.value);

    if(!state.call.value.isVoice) {
      fetchWallet();
      streamSubscription = CommonUtility.fetch(action: () => fetchWallet(), durationInSeconds: 60);
    }

    super.onReady();
  }

  void _createCall() async {
    _updateCall(state.call.value.copyWith(status: CallStatus.calling), removeEmpty: false);
    var response = await _connect.post(
        endpoint: "/call/start",
        body: {"user": state.call.value.user, "type": state.call.value.type.value}
    );

    String? channel;
    if(response.isOk) {
      channel = ActiveCallResponse.fromJson(response.data).channel;
    }

    if(state.shouldEndCall.isFalse) {
      if(response.isOk) {
        ActiveCallResponse call = ActiveCallResponse.fromJson(response.data);
        _updateCall(call);
        _playRingtone();
        _initializeEngine();
      } else {
        notify.error(message: response.message);
        _disposeEngines();
      }
    } else {
      end(closeOverlays: true, channel: channel);
    }
  }

  void _updateCall(ActiveCallResponse call, {bool removeEmpty = true}) {
    state.call.value = call;
    if(canDispose(call) || call.isNullable) {
      if(removeEmpty) {
        EventController.data.removeCallByChannel("");
      }
    } else {
      EventController.data.addCall(this);
    }
  }

  bool isUnaccepted(ActiveCallResponse call) => call.status == CallStatus.missed || call.status == CallStatus.declined;

  bool isEnded(ActiveCallResponse call) => call.status == CallStatus.closed;

  bool canDispose(ActiveCallResponse call) => isUnaccepted(call) || isEnded(call) || call.status == CallStatus.disconnected;

  void _playRingtone() {
    _player.setAsset(Media.outgoingRingtone);
    _player.setVolume(0.1);
    _player.setLoopMode(LoopMode.one);
    _player.play();
  }

  void _initializeEngine() async  {
    if(state.call.value.isVoice) {
      streamCall = stream.StreamVideo.instance.makeCall(
        callType: stream.StreamCallType.custom("voice"),
        id: state.call.value.channel,
      );
    } else {
      streamCall = stream.StreamVideo.instance.makeCall(
        callType: stream.StreamCallType.custom("tip2fix"),
        id: state.call.value.channel,
      );
    }

    final result = await streamCall.getOrCreate(
        ringing: true,
        memberIds: [state.call.value.user],
        custom: {"image": state.call.value.image, "category": state.call.value.category}
    );

    if (result.isSuccess) {
      state.isInitialized.value = true;
      _eventListener();
      _addDeviceSubscription();

      if (!streamCall.hasPermission(stream.CallPermission.sendAudio)) {
        streamCall.requestPermissions([stream.CallPermission.sendAudio]);
      }
    }
  }

  void _eventListener() {
    streamCall.callEvents.on<stream.StreamCallAcceptedEvent>((event) {
      log("Accepted event ${event.createdAt}", from: "Stream Call Event");

      if(!state.call.value.isVoice) {
        state.call.value = state.call.value.copyWith(session: state.call.value.session + 1);
      }

      _updateStatus(CallStatus.onCall);
      _stopRingtone();

      streamCall.setMicrophoneEnabled(enabled: state.isAudioMuted.value);
      _setSpeakerphoneEnabled(enabled: state.isOnSpeaker.value);
    });

    streamCall.callEvents.on<stream.StreamCallRejectedEvent>((event) {
      log("Rejected event ${event.rejectedByUserId}", from: "Stream Call Event");

      stream.StreamVideo.instance.pushNotificationManager?.endAllCalls();
      Navigate.back();
      _disposeEngines();
    });

    streamCall.callEvents.on<stream.StreamCallRingingEvent>((event) {
      log("Ringing event ${event.sessionId}", from: "Stream Call Event");
      _updateStatus(CallStatus.ringing);
    });

    streamCall.callEvents.on<stream.StreamCallEndedEvent>((event) {
      log("Ended event ${event.endedBy}", from: "Stream Call Event");
      stream.StreamVideo.instance.pushNotificationManager?.endAllCalls();
      Navigate.back();
      _disposeEngines();
    });

    streamCall.callEvents.on<stream.StreamCallDisconnectedEvent>((event) {
      log("Disconnected event ${event.closeReason}", from: "Stream Call Event");
      stream.StreamVideo.instance.pushNotificationManager?.endAllCalls();
      Navigate.back();
      _disposeEngines();
    });

    streamCall.callEvents.on<stream.StreamCallCustomEvent>((event) {
      log("Custom event $event", from: "Stream Call Event");
      if(event.eventType == "session_update" && event.senderUserId != Database.auth.id) {
        state.call.value = state.call.value.copyWith(
            session: int.tryParse("${event.custom?["session"] ?? state.call.value.session}") ?? state.call.value.session
        );
      }
    });

    streamCall.state.valueStream.listen((event) {
      log(event.status, from: "Stream Call Status Stream");

      if(event.status.isIncoming && state.call.value.isRinging) {
        state.call.value = state.call.value.copyWith(channel: streamCall.callCid.id);
      } else if(event.status.isDisconnected && state.call.value.isRinging) {
        stream.StreamVideo.instance.pushNotificationManager?.endAllCalls();
        Navigate.back();
        _disposeEngines();
      } else if(event.status.isDisconnected && state.call.value.isOnCall) {
        stream.StreamVideo.instance.pushNotificationManager?.endAllCalls();
        Navigate.back();
        _disposeEngines();
      } else if(event.status.isActive || (event.status.isConnected && !state.call.value.isRinging)) {
        _stopRingtone();
        _buildTimer(event);
      }
    });
  }

  void _stopRingtone() {
    _player.stop();
  }

  void _updateStatus(CallStatus status) {
    state.call.value = state.call.value.copyWith(status: status);

    if(canDispose(state.call.value) || state.call.value.isNullable) {
      EventController.data.removeCallByChannel(state.call.value.channel);

      if(state.isInitialized.value) {
        streamCall.leave();
      }

      _disposeEngines();

      if(isUnaccepted(state.call.value)) {
        _connect.patch(
          endpoint: "/call/update",
          body: {
            "status": status.value,
            "channel": state.call.value.channel
          }
        );
      } else if(isEnded(state.call.value)) {
        _connect.patch(
          endpoint: "/call/update",
          body: {
            "status": status.value,
            "channel": state.call.value.channel,
            "time": state.duration.value
          }
        );
      }
    }
  }

  void _buildTimer(stream.CallState event) {
    if (event.status.isConnected) {
      _updateStatus(CallStatus.onCall);
      _startedAt ??= DateTime.now();

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _duration = DateTime.now().difference(_startedAt!);
        final int totalMinutes = _duration.inMinutes;
        final int totalSeconds = _duration.inSeconds;

        final int hours = _duration.inHours;
        final int minutes = totalMinutes.remainder(60);
        final int seconds = totalSeconds.remainder(60);

        if (hours > 0) {
          state.duration.value = '${hours.toString().padLeft(2, '0')}:'
              '${minutes.toString().padLeft(2, '0')}:'
              '${seconds.toString().padLeft(2, '0')}';
        } else {
          state.duration.value = '${minutes.toString().padLeft(2, '0')}:'
              '${seconds.toString().padLeft(2, '0')}';
        }
        _checkAndPaySession(totalMinutes);
      });

      _periodicVideoCheck();
      _periodicAudioCheck();
    } else {
      _timer?.cancel();
      state.duration.value = event.status.toStatusString();
    }
  }

  void _periodicVideoCheck() {
    Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      bool callMemberVideoNotEnabled = state.isInitialized.isTrue
          && streamCall.state.value.otherParticipants.isNotEmpty
          && streamCall.state.value.otherParticipants.any((p) => !p.isLocal && !p.isVideoEnabled);

      if(!state.call.value.isVoice && callMemberVideoNotEnabled) {
        notify.tip(
          message: "We noticed that you cannot see ${state.call.value.name} video. Wait a moment while we work on finding out why.",
          color: CommonColors.success
        );
      }
    });
  }

  void _periodicAudioCheck() {
    Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      if(localParticipant != null && (!localParticipant!.isSpeaking || (localParticipant!.isSpeaking && state.isAudioMuted.value))) {
        if(state.isAudioMuted.value) {
          notify.tip(message: "Trying to speak? Unmute yourself so you can be heard", color: CommonColors.success);
        } else {
          notify.tip(message: "You've been quiet for a long time. Share your thoughts with ${state.call.value.name}", color: CommonColors.allday);
        }
      }
    });
  }

  void _checkAndPaySession(int totalMinutes) async {
    log(totalMinutes, from: "Call Check and Pay Session Checker Minutes");

    bool isTime = (totalMinutes == Keys.tip2fixSession && state.paymentTrials.value == 0)
        || (totalMinutes == (Keys.tip2fixSession + 1) && state.paymentTrials.value == 1)
        || (totalMinutes == (Keys.tip2fixSession + 2) && state.paymentTrials.value == 2);

    if (isTime && !state.call.value.isVoice) {
      log(totalMinutes, from: "Call Check and Pay Session Checker - Take Action");
      var response = await _connect.patch(
        endpoint: "/call/session",
        body: {
          "duration": totalMinutes,
          "channel": state.call.value.channel
        }
      );

      if(response.isOk) {
        ActiveCallResponse call = ActiveCallResponse.fromJson(response.data);

        if(call.error != null && call.error!.isNotEmpty) {
          state.paymentTrials.value = state.paymentTrials.value++;

          CallNotifierSheet.open(channel: state.call.value.channel, message: call.error!, asset: asset);

          Future.delayed(const Duration(seconds: 5), () {
            if(Get.isBottomSheetOpen ?? false) {
              Navigate.back();
            }
          });

          if(call.errorCode != null && call.errorCode!.isNotEmpty && state.paymentTrials.value == 3) {
            Future.delayed(const Duration(seconds: 5), () {
              end();
            });
          }
        } else {
          streamCall.sendCustomEvent(eventType: "session_update", custom: {"session": call.session});
          _updateCall(call);
        }
      } else {
        notify.tip(message: response.message, color: CommonColors.error);
      }
    }
  }

  void _addDeviceSubscription() {
    _deviceNotifier = stream.RtcMediaDeviceNotifier.instance;

    _deviceChangeSubscription = _deviceNotifier?.onDeviceChange.listen((devices) {
      final audioOutputs = devices.where((it) {
        return it.kind == stream.RtcMediaDeviceKind.audioOutput;
      });
      _audioOutputs = audioOutputs.toList();
    });
  }

  void _answerCall() async {
    if(state.call.value.isVoice) {
      streamCall = stream.StreamVideo.instance.makeCall(
        callType: stream.StreamCallType.custom("voice"),
        id: state.call.value.channel,
      );

      state.isInitialized.value = true;
    } else {
      streamCall = stream.StreamVideo.instance.makeCall(
        callType: stream.StreamCallType.custom("tip2fix"),
        id: state.call.value.channel,
      );

      state.isInitialized.value = true;
    }

    if(state.isInitialized.value) {
      remoteNotificationAction.dismissGroupedNotifications(state.call.value.channel);
      _eventListener();
      _addDeviceSubscription();

      if (!streamCall.hasPermission(stream.CallPermission.sendAudio)) {
        streamCall.requestPermissions([stream.CallPermission.sendAudio]);
      }
    }
  }

  void answer() async {
    _updateCall(getCallFromStreamCall(call: streamCall));
    var acceptResult = await streamCall.accept();

    // Return if cannot accept call
    if(acceptResult.isFailure) {
      notify.error(message: "Error occurred while accepting call");
      CrashlyticsEngine.logError(acceptResult.getErrorOrNull()?.message.toString() ?? acceptResult.toString(), "ACCEPT CALL");

      streamCall.leave();
      _disposeEngines();
      return;
    }

    remoteNotificationAction.dismissGroupedNotifications(state.call.value.channel);

    var response = await _connect.patch(
      endpoint: "/call/update",
      body: {
        "status": CallStatus.onCall.value,
        "channel": state.call.value.channel
      }
    );

    if(response.isOk) {
      ActiveCallResponse call = ActiveCallResponse.fromJson(response.data);
      _updateCall(call);
    } else {
      notify.error(message: response.message);
      streamCall.leave();
      _disposeEngines();
    }
  }

  void decline() async {
    _updateCall(getCallFromStreamCall(call: streamCall));

    final result = await streamCall.reject(reason: stream.CallRejectReason.decline());
    stream.StreamVideo.instance.pushNotificationManager?.endAllCalls();

    if (result is stream.Failure) {
      CrashlyticsEngine.logError(result.getErrorOrNull()?.message.toString() ?? result.error.message, "REJECT CALL");

      Navigate.back();
      streamCall.leave();
      _disposeEngines();
      return;
    }

    remoteNotificationAction.dismissGroupedNotifications(state.call.value.channel);

    Navigate.back();
    await _connect.patch(endpoint: "/call/update", body: {"status": CallStatus.declined.value, "channel": state.call.value.channel});
    _disposeEngines();
  }

  void end({bool closeOverlays = false, String? channel}) async {
    if(state.call.value.isCalling || state.isInitialized.isFalse) {
      /// Call endpoint to end call that is not in a ringing state
      state.shouldEndCall.value = true;
      log("Hey $channel");
      Navigate.back();
      EventController.data.removeCallByChannel("");

      if(channel != null || state.call.value.channel.isNotEmpty) {
        await _connect.patch(endpoint: "/call/update", body: {"status": CallStatus.missed.value, "channel": channel ?? state.call.value.channel});

        try {
          streamCall.end();
          streamCall.leave();
        } catch (_) {}
        _disposeEngines();
      }

      _disposeEngines();
    } else {
      ActiveCallResponse call = getCallFromStreamCall(call: streamCall);
      state.call.value = state.call.value.copyWith(channel: call.channel);

      Navigate.back();
      streamCall.end();
      streamCall.leave();

      if(state.call.value.isOnCall) {
        await _connect.patch(endpoint: "/call/update", body: {"status": CallStatus.closed.value, "channel": state.call.value.channel, "time": state.duration.value});
      } else {
        await _connect.patch(endpoint: "/call/update", body: {"status": CallStatus.missed.value, "channel": state.call.value.channel});
      }
      _disposeEngines();
    }
  }

  /// Function to dispose the RTC engine.
  void _disposeEngines() async {
    _timer?.cancel();
    _player.dispose();

    streamSubscription?.cancel();
    _deviceChangeSubscription?.cancel();
    EventController.data.removeCallByChannel(state.call.value.channel);
    CallChannelListController.data.callController.refresh();

    if(Get.isBottomSheetOpen ?? false) {
      Navigate.back(closeOverlays: true);
    }

    remoteNotificationAction.dismissGroupedNotifications(state.call.value.channel);

    stream.StreamVideo.instance.pushNotificationManager?.endAllCalls();
    Navigate.till(ModalRoute.withName(ParentLayout.route));

    try {
      if (Get.isRegistered<CallController>()) {
        log('Deleting CallController');
        Get.delete<CallController>(force: true);
      }
    } catch (_) {}
  }

  void goBack(bool value, Object? result) {
    log("Go back called here");
    Navigate.back(closeOverlays: true);
  }

  String get asset => state.call.value.isVoice ? Media.voiceChat : Media.videoChat;

  void fetchWallet() async {
    state.isFetchingWallet.value = true;
    var response = await _connect.get(endpoint: "/wallet");
    if(response.isSuccessful) {
      Wallet wallet = Wallet.fromJson(response.data);
      state.wallet.value = wallet;
      state.isFetchingWallet.value = false;
    }
  }

  void toggleMic() async {
    state.isAudioMuted.toggle();
    if(state.isInitialized.value) {
      streamCall.setMicrophoneEnabled(enabled: !state.isAudioMuted.value);
    }
  }

  void toggleSpeaker() async {
    state.isOnSpeaker.toggle();
    if (state.isOnSpeaker.value) {
      if(state.call.value.isCalling) {
        _player.setVolume(0.1);
      }
    } else {
      if(state.call.value.isCalling) {
        _player.setVolume(1.0);
      }
    }

    if(state.isInitialized.value) {
      if (!streamCall.hasPermission(stream.CallPermission.sendAudio)) {
        streamCall.requestPermissions([stream.CallPermission.sendAudio]);
      }

      _setSpeakerphoneEnabled(enabled: state.isOnSpeaker.value);
    }
  }

  Future<void> _setSpeakerphoneEnabled({bool enabled = false}) async {
    final audioOutputs = _audioOutputs;
    if (audioOutputs.isEmpty) return;

    var device = audioOutputs.firstWhereOrNull((it) {
      return it.id.equalsIgnoreCase(enabled ? stream.deviceIdSpeaker : stream.deviceIdEarpiece);
    });

    if (!enabled && device == null) {
      // In IOS, we don't have earpiece as a listed device. So we will try to
      // create a new device with the earpiece ID.
      if (stream.CurrentPlatform.isIos) {
        device = const stream.RtcMediaDevice(
          id: stream.deviceIdEarpiece,
          kind: stream.RtcMediaDeviceKind.audioOutput,
          label: 'Earpiece',
        );
      }
    }

    // If we don't have a device, we can't set it as the audio output.
    if (device == null) return;

    // Set the device as the current audio output.
    await streamCall.setAudioOutputDevice(device);
  }

  void toggleCamera() {
    state.isCameraEnabled.toggle();
    if(state.isInitialized.value) {
      streamCall.setCameraEnabled(enabled: state.isCameraEnabled.value);
    }
  }

  void invite() async {
    state.isInviting.value = true;

    ApiResponse response = await _connect.post(
      endpoint: "/trip/request",
      body: {
        "address": state.search.value.address.place,
        "latitude": state.search.value.address.latitude,
        "longitude": state.search.value.address.longitude,
        "provider": state.call.value.user,
        "place_id": state.search.value.address.id,
        "amount": amount.text
      }
    );

    state.isInviting.value = false;
    if(response.isSuccessful) {
      TripResponse trip = TripResponse.fromJson(response.data);
      ActivityActiveController.data.addTrip(trip);

      end(closeOverlays: true);
      ActivityRequestedTripView.open(trip);
    } else {
      notify.error(message: response.message);
    }
  }

  stream.CallParticipantState? get remoteParticipant => streamCall.state.value.callParticipants
      .where((p) => !p.isLocal).firstOrNull;

  stream.CallParticipantState? get localParticipant => streamCall.state.value.callParticipants
      .where((e) => e.isLocal).firstOrNull;
}

extension on String {
  bool equalsIgnoreCase(String other) => toUpperCase() == other.toUpperCase();
}