import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user/library.dart';

class CallController extends GetxController {
  CallController();
  final state = CallState();
  final args = Get.arguments;

  final ConnectService _connect = Connect();
  final SocketService _socket = Socket();
  final HomeController _homeController = HomeController.data;
  final NotificationBuildService _notification = NotificationBuildImplementation();

  final player = AudioPlayer();
  late final RtcEngine engine;

  @override
  void onInit() {
    state.call.value = ActiveCallResponse.fromJson(args["call"]);
    // _homeController.event.addCallEvent(this);
    // _notification.buildCallTracker(state.call.value);

    if(state.call.value.isCalling) {
      playRingingTone();
    }
    super.onInit();
  }

  void playRingingTone() {
    player.setLoopMode(LoopMode.one);
    player.setVolume(2.0);
    if(state.call.value.isCaller) {
      log("Caller");
      player.setAudioSource(AudioSource.asset(Media.outgoingRingtone));
    } else {
      log("Called");
      player.setAudioSource(AudioSource.asset(Media.incomingRingtone));
    }
    player.play();
  }

  @override
  void onReady() {
    bool shouldAnswer = args["answer"];
    if(shouldAnswer) {
      answer();
      _initializeEngine(state.call.value.app, state.call.value.channel);
      _socket.initialize(
        callback: (frame) {
          if (frame.body != null) {
            workWithData(jsonDecode(frame.body!));
          }
        },
        endpoint: "/ws:serch",
        subscribeDestination: "/platform/${state.call.value.channel}/${Database.auth.id}"
      );
    }

    bool shouldStart = args["start"];
    if(state.call.value.isCaller && shouldStart) {
      start();
    }
    super.onReady();
  }

  void workWithData(dynamic data) {
    if(data is String) {
      notify.tip(message: data, color: CommonColors.error);
    } else {
      ActiveCallResponse call = ActiveCallResponse.fromJson(data);
      state.call.value = call;
      // _notification.updateCallTracker(call);
      if(call.error != null && call.errorCode != null) {
        notify.tip(message: call.error!, color: CommonColors.error);
      } else {
        if(call.status == CallStatus.onCall) {
          stopRingingTone();
          return;
        }

        if(call.status == CallStatus.declined) {
          disposeEngines();
          Navigate.back();
          // _homeController.event.removeCallEventByChannel(call.channel);
          return;
        }

        if(call.status == CallStatus.disconnected) {
          leave();
          return;
        }

        if(call.status == CallStatus.closed) {
          disposeEngines();
          Navigate.back(closeOverlays: true);
          return;
        }
      }
    }
  }

  void start() async {
    state.call.value = state.call.value.copyWith(status: CallStatus.calling);
    var response = await _connect.post(endpoint: "/call/start", body: {
      "user": state.call.value.user,
      "type": state.call.value.type.value
    });

    if(response.isOk) {
      ActiveCallResponse call = ActiveCallResponse.fromJson(response.data);
      state.call.value = call;
      _initializeEngine(call.app, call.channel);
      _socket.initialize(
        callback: (frame) {
          if (frame.body != null) {
            workWithData(jsonDecode(frame.body!));
          }
        },
        endpoint: "/ws:serch",
        subscribeDestination: "/platform/${call.channel}/${Database.auth.id}"
      );
    } else {
      notify.error(message: response.message);
      state.call.value = state.call.value.copyWith(status: CallStatus.disconnected);
      leave();
    }
  }

  void answer() async {
    _socket.send(destination: "/call/answer", message: {
      "channel": state.call.value.channel
    });
  }

  void decline() async {
    _socket.send(destination: "/call/decline", message: {
      "channel": state.call.value.channel
    });
  }

  void end({bool closeOverlays = false}) async {
    if(state.call.value.isCalling) {
      /// Call endpoint to end call that is not in a ringing state
      updateStatus(CallStatus.missed);
      disposeEngines();
      Navigate.back();
      // _notification.endCallTracker(state.call.value);
    } else {
      _socket.send(destination: "/call/end", message: {
        "channel": state.call.value.channel
      });
    }
  }

  void updateStatus(CallStatus status) {
    _socket.send(destination: "/call/update", message: {
      "channel": state.call.value.channel,
      "status": status.value
    });
  }

  void leave() {
    Future.delayed(const Duration(seconds: 2), () {
      _socket.disconnect();
      // _notification.endCallTracker(state.call.value);
      // _homeController.event.removeCallEventByChannel(state.call.value.channel);
      Navigate.till(ModalRoute.withName(HomeLayout.route));
    });
  }

  void stopRingingTone() {
    player.stop();
    player.dispose();
  }

  void _initializeEngine(String appId, String channel) async  {
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: appId)).then((value) async {
      state.isInitialized.value = true;
      /// Set the audio route to speaker when the call is not yet picked and the user is the one being called
      if(!state.call.value.isCaller && state.call.value.isRinging) {
        // await engine.setDefaultAudioRouteToSpeakerphone(true);
      }
    });

    // var play = await engine.media;

    if(!state.call.value.isVoice) {
      await engine.enableVideo();
    }
    await engine.startPreview().then((value) {
      state.isPreviewReady.value = true;
    });

    /// Event handlers
    engine.registerEventHandler(RtcEngineEventHandler(
      onLeaveChannel: (connection, stats) async {
        leaveChannel();
      },
      onJoinChannelSuccess: (connection, elapsed) async {
        calculateCallTime(elapsed);
        if(state.call.value.isVoice) {
          /// Don't show the video
          engine.muteLocalVideoStream(true);
        }

        if(!state.call.value.isCaller) {
          stopRingingTone();
        }
        Logger.log(" : Call Elapsed. Connection: ${connection.toJson()}. Duration: $elapsed");
      },
      onConnectionLost: (connection) {
        state.call.value = state.call.value.copyWith(status: CallStatus.reconnecting);
      },
      onConnectionBanned: (connection) {
        state.call.value = state.call.value.copyWith(status: CallStatus.reconnecting);
      },
      onConnectionInterrupted: (connection) {
        state.call.value = state.call.value.copyWith(status: CallStatus.reconnecting);
      },
      onRtcStats: (connection, stats) async {
        if(state.call.value.isCaller) {
          disconnectAfterTimeout(stats.duration);
        } else {
          leaveAfterTimeout();
        }

        if(state.call.value.isOnCall && !state.call.value.isVoice) {
          /// Start counting the call session.
          calculateSession(stats.duration ?? 0);
        }
      },
      onRejoinChannelSuccess: (connection, elapsed) {
        state.call.value = state.call.value.copyWith(status: CallStatus.onCall);
      },
      onUserJoined: (connection, remoteUid, elapsed) async {
        if(state.call.value.isCaller) {
          stopRingingTone();
          state.call.value = state.call.value.copyWith(status: CallStatus.onCall);
          calculateCallTime(elapsed);
        }
        Logger.log(" : User joined. Connection: ${connection.toJson()}. Duration: $elapsed");
      },
      onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
        _fetchToken(channel, false);
      },
      onRequestToken: (RtcConnection connection) {
        _fetchToken(channel, true);
      },
    ));

    await _fetchToken(channel, true);
  }

  Future<void> _fetchToken(String channelName, bool needJoinChannel) async {
    ApiResponse response = await _connect.get(endpoint: "/call/auth?channel=$channelName");
    if(response.isSuccessful) {
      if (needJoinChannel) {
        await engine.joinChannelWithUserAccount(
          token: response.data,
          channelId: channelName,
          userAccount: Database.auth.id,
          options: const ChannelMediaOptions(
            channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
            clientRoleType: ClientRoleType.clientRoleBroadcaster,
          ),
        );
      } else {
        await engine.renewToken(response.data);
      }
    } else {
      notify.tip(message: response.message, color: CommonColors.error);
    }
  }

  void leaveAfterTimeout() {
    if(state.call.value.isMissed) {
      updateStatus(CallStatus.missed);
      disposeEngines();
      Navigate.back();
    }
  }

  void leaveChannel() async {
    if(state.call.value.isOnCall) {
      updateStatus(CallStatus.closed);
    } else if(state.call.value.isRinging) {
      updateStatus(CallStatus.missed);
    }
  }

  String formatNumberToTime(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }
    return numberStr;
  }

  void calculateCallTime(int duration) {
    int hours = duration ~/ 3600; // Calculate the hours
    int remainingSeconds = duration % 3600; // Calculate the remaining seconds after subtracting hours

    int minutes = remainingSeconds ~/ 60; // Calculate the minutes
    int seconds = remainingSeconds % 60; // Calculate the remaining seconds after subtracting minutes

    state.hours.value = formatNumberToTime(hours);
    state.minutes.value = formatNumberToTime(minutes);
    state.seconds.value = formatNumberToTime(seconds);

    if(state.hours.value.isEmpty) {
      state.time.value = "${state.minutes.value}:${state.seconds.value}";
    } else {
      state.time.value = "${state.hours.value}:${state.minutes.value}:${state.seconds.value}";
    }
  }

  void disconnectAfterTimeout(int? duration) async {
    if(duration == state.timeout.value && (state.call.value.isCalling || state.call.value.isRinging)) {
      disposeEngines();
      updateStatus(CallStatus.missed);
    }
  }

  void calculateSession(int duration) async {
    _socket.send(destination: "/call/session", message: {
      "channel": state.call.value.channel,
      "duration": duration
    });
  }

  /// Function to mute/un-mute the microphone
  Future<void> toggleMute() async {
    var status = await Permission.microphone.status;
    if(state.isAudioMuted.value && status.isDenied) {
      await Permission.microphone.request();
    }
    state.isAudioMuted.value = !state.isAudioMuted.value;
    await engine.muteLocalAudioStream(state.isAudioMuted.value);
  }

  /// Function to toggle enable/disable the camera
  Future<void> toggleCamera() async {
    var status = await Permission.camera.status;
    if(state.isVideoMuted.value && status.isDenied) {
      await Permission.camera.request();
    }
    state.isAudioMuted.value = !state.isAudioMuted.value;
    await engine.muteLocalVideoStream(state.isVideoMuted.value);
  }

  /// Function to switch between front and rear camera
  Future<void> switchCamera() async {
    var status = await Permission.camera.status;
    if(status.isDenied) {
      await Permission.camera.request();
    }
    await engine.switchCamera();
  }

  /// Function to dispose the RTC engine.
  void disposeEngines() async {
    await engine.stopPreview();
    await engine.leaveChannel();
    await engine.release();
    _socket.disconnect();
    stopRingingTone();
  }
}