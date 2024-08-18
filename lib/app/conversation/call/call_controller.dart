import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;
import 'package:user/library.dart';

class CallController extends GetxController {
  CallController();
  final state = CallState();
  final args = Get.arguments;

  final ConnectService _connect = Connect();
  final SocketService _socket = Socket();
  final HomeController _homeController = HomeController.data;

  final TextEditingController amount = TextEditingController();

  late stream.Call streamCall;
  StreamSubscription<dynamic>? streamSubscription;
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
    bool shouldStart = args["start"];
    if(shouldStart) {
      createCall();
    }

    if(args["stream"] != null) {
      streamCall = args["stream"];
      _initSocket(streamCall.callCid.id);
      state.isInitialized.value = true;
      eventListener();
    }

    amount.addListener(() {
      if(amount.text.trim().isNotEmpty) {
        state.amount.value = amount.text.trim();
      }
    });

    updateCall(state.call.value);

    if(state.call.value.channel.isNotEmpty) {
      _initSocket(state.call.value.channel);
    }

    if(!state.call.value.isVoice) {
      fetchWallet();
      streamSubscription = CommonUtility.fetch(action: () => fetchWallet(), durationInSeconds: 60);
    }

    super.onReady();
  }

  void updateCall(ActiveCallResponse call, {bool removeEmpty = true}) {
    state.call.value = call;
    _homeController.event.addCallEvent(this);

    if(removeEmpty) {
      _homeController.event.removeCallEventByChannel("");
    }
    // _notification.buildCallTracker(state.call.value);
  }

  void createCall() async {
    updateCall(state.call.value.copyWith(status: CallStatus.calling), removeEmpty: false);
    log(state.call.value.type.value);
    var response = await _connect.post(
        endpoint: "/call/start",
        body: {"user": state.call.value.user, "type": state.call.value.type.value}
    );

    if(response.isOk) {
      ActiveCallResponse call = ActiveCallResponse.fromJson(response.data);
      updateCall(call);
      _playRingtone();
      _initializeEngine();
      _initSocket(call.channel);
    } else {
      notify.error(message: response.message);
      _leave();
    }
  }

  void _playRingtone() {
    _player.setAsset(Media.outgoingRingtone);
    _player.setVolume(0.1);
    _player.setLoopMode(LoopMode.one);
    _player.play();
  }

  void _stopRingtone() {
    _player.stop();
  }

  void toggleRingingMic() async {
    if (state.isAudioMuted.value) {
      streamCall.setMicrophoneEnabled(enabled: false);
      updateAudio(false);
    } else {
      if (!streamCall.hasPermission(stream.CallPermission.sendAudio)) {
        streamCall.requestPermissions([stream.CallPermission.sendAudio]);
      }
      streamCall.setMicrophoneEnabled(enabled: true);
      updateAudio(true);
    }
  }

  void updateAudio(bool value) {
    state.isAudioMuted.value = value;
  }

  void toggleRingingSpeaker() async {
    if (state.isOnSpeaker.value) {
      _player.setVolume(0.1);
      updateSpeaker(false);
    } else {
      _player.setVolume(1.0);
      updateSpeaker(true);
    }
  }

  void updateSpeaker(bool value) {
    state.isOnSpeaker.value = value;
  }

  void _initializeEngine() async  {
    if(state.call.value.isVoice) {
      streamCall = stream.StreamVideo.instance.makeCall(
        callType: stream.StreamCallType.custom("voice"),
        id: state.call.value.channel,
      );

      final result = await streamCall.getOrCreate(
        ringing: true,
        memberIds: [state.call.value.user],
        custom: {"image": state.call.value.image, "category": state.call.value.category}
      );
      if (result.isSuccess) {
        state.isInitialized.value = true;
      }
    } else {
      streamCall = stream.StreamVideo.instance.makeCall(
        callType: stream.StreamCallType.custom("tip2fix"),
        id: state.call.value.channel,
      );

      final result = await streamCall.getOrCreate(
        ringing: true,
        memberIds: [state.call.value.user],
        custom: {"image": state.call.value.image, "category": state.call.value.category}
      );
      if (result.isSuccess) {
        state.isInitialized.value = true;
      }
    }

    if(state.isInitialized.value) {
      eventListener();
    }
  }

  void eventListener() {
    streamCall.callEvents.on<stream.StreamCallAcceptedEvent>((event) {
      log("Accepted event ${event.createdAt}");
      _stopRingtone();
    });

    streamCall.callEvents.on<stream.StreamCallRejectedEvent>((event) {
      if(event.rejectedBy.id != Database.auth.id) {
        _updateStatus(CallStatus.declined);
      } else {
        _updateStatus(CallStatus.missed);
      }
    });

    streamCall.callEvents.on<stream.StreamCallRingingEvent>((event) {
      log("Ringing event ${event.sessionId}");
    });

    streamCall.callEvents.on<stream.StreamCallEndedEvent>((event) {
      log("Ended event ${event.endedBy}");
      if(state.call.value.isRinging) {
        _updateStatus(CallStatus.missed);
      } else if(state.call.value.isOnCall) {
        _updateStatus(CallStatus.closed);
      }
    });

    streamCall.callEvents.on<stream.StreamCallDisconnectedEvent>((event) {
      log("Disconnected event ${event.closeReason}");
      if(state.call.value.isRinging) {
        _updateStatus(CallStatus.missed);
      } else if(state.call.value.isOnCall) {
        _updateStatus(CallStatus.closed);
      }
    });

    streamCall.state.valueStream.listen((event) {
      log(event.status);

      if(event.status.isDisconnected && state.call.value.isRinging) {
        _updateStatus(CallStatus.missed);
      } else if(event.status.isDisconnected && state.call.value.isOnCall) {
        _updateStatus(CallStatus.closed);
      } else if(event.status.isActive || (event.status.isConnected && !state.call.value.isRinging)) {
        _stopRingtone();
        _buildTimer(event);
      }
    });
  }

  void _buildTimer(stream.CallState event) {
    if(event.status.isConnected) {
      _startedAt ??= DateTime.now();

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _duration = DateTime.now().difference(_startedAt!);
        final int totalMinutes = _duration.inMinutes;
        final int seconds = _duration.inSeconds.remainder(60);

        if (_duration.inHours > 0) {
          final int hours = _duration.inHours;
          final int minutes = totalMinutes.remainder(60);

          state.duration.value = '${hours.toString().padLeft(2, '0')}:'
              '${minutes.toString().padLeft(2, '0')}:'
              '${seconds.toString().padLeft(2, '0')}';
        } else {
          state.duration.value = '${totalMinutes.toString().padLeft(2, '0')}:'
              '${seconds.toString().padLeft(2, '0')}';
        }

        int minutesToNextHour = 60 - (_duration.inMinutes % 60);
        if (minutesToNextHour <= 10) {
          _calculateSession(_duration.inMinutes);
        }
      });
    } else {
      if(_timer != null) {
        _timer?.cancel();
      }

      state.duration.value = event.status.toStatusString();
    }
  }

  void _calculateSession(int duration) async {
    _socket.send(destination: "/call/session", message: {
      "channel": state.call.value.channel,
      "duration": duration
    });
  }

  void _initSocket(String channel) {
    _socket.initialize(
      callback: (frame) {
        if (frame.body != null) {
          _workWithData(jsonDecode(frame.body!));
        }
      },
      endpoint: "/ws:serch",
      subscribeDestination: "/platform/$channel/${Database.auth.id}"
    );
  }

  void _workWithData(dynamic data) {
    if(data is String) {
      notify.tip(message: data, color: CommonColors.error);
    } else {
      ActiveCallResponse call = ActiveCallResponse.fromJson(data);
      updateCall(call);
      if(call.error != null && call.errorCode != null && call.error != "null") {
        if(state.call.value.isOnCall) {
          CallNotifierSheet.open(channel: state.call.value.channel, message: call.error!, asset: asset);
        } else {
          notify.tip(message: call.error!, color: CommonColors.error);
        }
      } else {
        if(call.status == CallStatus.onCall) {
          return;
        }

        if(call.status == CallStatus.declined) {
          _disposeEngines();
          Navigate.back();
          return;
        }

        if(call.status == CallStatus.disconnected) {
          _leave();
          return;
        }

        if(call.status == CallStatus.closed) {
          _disposeEngines();
          Navigate.back(closeOverlays: true);
          return;
        }
      }
    }
  }

  void _leave() {
    Future.delayed(const Duration(seconds: 2), () {
      _disposeEngines();
      Navigate.till(ModalRoute.withName(HomeLayout.route));
    });
  }

  void answer() async {
    var acceptResult = await streamCall.accept();

    // Return if cannot accept call
    if(acceptResult.isFailure) {
      notify.error(message: "Error occurred while accepting call");
      CrashlyticsEngine.logError(acceptResult.getErrorOrNull()?.message.toString() ?? acceptResult.toString(), "ACCEPT CALL");
      log('Error accepting call: ${state.call.value.channel}');
      return;
    }

    socket.send(destination: "/call/answer", message: {
      "channel": streamCall.callCid.id,
    });
  }

  void decline() async {
    final result = await streamCall.reject(reason: stream.CallRejectReason.decline());
    stream.StreamVideo.instance.pushNotificationManager?.endAllCalls();

    if (result is stream.Failure) {
      notify.error(message: "Error occurred while rejecting call");
      CrashlyticsEngine.logError(result.getErrorOrNull()?.message.toString() ?? result.error.message, "REJECT CALL");
      log('Error rejecting call: ${result.error}');
    }

    _updateStatus(CallStatus.declined);
  }

  void end({bool closeOverlays = false}) async {
    if(state.call.value.isCalling) {
      _updateStatus(CallStatus.missed);
      Navigate.back();
    } else {
      _socket.send(destination: "/call/end", message: {
        "channel": state.call.value.channel,
        "time": state.duration.value
      });
      _disposeEngines();
      streamCall.leave();
    }
  }

  void _updateStatus(CallStatus status) {
    if(_socket.stompClient.connected) {
      _socket.send(destination: "/call/update", message: {
        "channel": state.call.value.channel,
        "status": status.value
      });

      if(status == CallStatus.missed || status == CallStatus.declined || status == CallStatus.closed) {
        _disposeEngines();
      }
    }
  }

  /// Function to dispose the RTC engine.
  void _disposeEngines() async {
    try {
      if (_socket.stompClient.isActive && _socket.stompClient.connected) {
        _socket.disconnect();
      }
    } catch (_) { }

    _timer?.cancel();
    _player.dispose();
    amount.dispose();
    streamSubscription?.cancel();
    _homeController.event.removeCallEventByChannel(state.call.value.channel);
    _homeController.call.fetchCalls(showLoader: false);

    try {
      Get.delete<CallController>(force: true);
    } catch (_) { }
  }

  void goBack(bool value, Object? result) {
    log("Go back called here");
    if(state.call.value.isCalling) {
      _disposeEngines();
    }

    // end();
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

  void invite() async {}
}