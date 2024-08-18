import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';
import 'package:user/library.dart';
import 'package:user/enums/library.dart' as status;

class CallConfiguration extends GetxController {
  final StreamVideo? videoClient;
  CallConfiguration({this.videoClient});

  static CallConfiguration get data => Get.find<CallConfiguration>();

  static void bind() {
    try {
      if(!CallConfiguration.data.initialized) {
        Get.put<CallConfiguration>(CallConfiguration());
      }
    } catch (_) {
      Get.put<CallConfiguration>(CallConfiguration());
    }
  }

  final Connect _connect = Connect();

  late StreamVideo client;
  final _callKitEventSubscriptions = Subscriptions();

  @override
  void onInit() {
    _init();
    _tryConsumingIncomingCallFromTerminatedState();

    super.onInit();
  }

  void _init() async  {
    if(videoClient != null) {
      client = videoClient!;
    } else {
      client = StreamVideo(
        Keys.streamApiKey,
        user: User(info: Database.auth.toUserInfo()),
        options: const StreamVideoOptions(
          logPriority: Priority.info,
          muteAudioWhenInBackground: true,
          muteVideoWhenInBackground: true,
        ),
        pushNotificationManagerProvider: StreamVideoPushNotificationManager.create(
            iosPushProvider: CallPushProviderSetup.iosConfig,
            androidPushProvider: CallPushProviderSetup.androidConfig,
            pushParams: CallPushProviderSetup.videoPushParams,
            backgroundVoipCallHandler: backgroundCallHandler
        ),
        tokenLoader: _tokenLoader,
        onTokenUpdated: (token) async {},
      );
    }

    client.connect();
  }

  Future<String> _tokenLoader(String user) async {
    final ApiResponse response = await _connect.get(endpoint: "/call/authentication");
    if(response.isSuccessful) {
      return response.data;
    } else {
      return "";
    }
  }

  void _tryConsumingIncomingCallFromTerminatedState() {
    if (Navigate.navigatorKey.currentContext == null) {
      // App is not running yet. Postpone consuming after app is in the foreground
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _consumeIncomingCall();
      });
    } else {
      // no-op. If the app is already running we'll handle it via events
    }
  }

  Future<void> _consumeIncomingCall() async {
    final calls =
    await StreamVideo.instance.pushNotificationManager?.activeCalls();

    if (calls == null || calls.isEmpty) return;

    final callResult = await StreamVideo.instance.consumeIncomingCall(
      uuid: calls.first.uuid!,
      cid: calls.first.callCid!,
    );

    callResult.fold(success: (result) async {
      final call = result.data;
      await call.accept();

      _onNavigateToCall(result.data);
    }, failure: (error) {
      notify.error(message: "Error consuming incoming call");
      CrashlyticsEngine.logError(error.toString(), "CONSUME CALL CONFIGURATION");
      log('Error consuming incoming call: $error');
    });
  }

  void _endAllCalls() {
    client.pushNotificationManager?.endAllCalls();
  }

  @override
  void onReady() {
    try {
      StreamBackgroundService.init(
        client,
        callNotificationOptionsBuilder: (call) {
          String image = call.state.value.callParticipants.isNotEmpty
              ? call.state.value.callParticipants.first.image ?? ""
              : call.state.value.localParticipant != null
              ? call.state.value.localParticipant!.image ?? ""
              : "";

          return NotificationOptions(
              content: NotificationContent(
                  title: call.type.value.toLowerCase() == "voice" ? "Voice Call" : "Tip2Fix Call",
                  text: call.state.value.status.toStatusString()
              ),
              avatar: NotificationAvatar(url: image),
              useCustomLayout: true
          );
        },
        onNotificationClick: (call) async => _onNavigateToCall(call),
      );
      client.state.incomingCall.listen(_onNavigateToCall);

      _observeCallKitEvents();
    } catch (e) {
      CrashlyticsEngine.logError(e.toString(), "STREAM BACKGROUND INITIALIZATION - CALL CONFIGURATION");
    }

    super.onReady();
  }

  void _onNavigateToCall(Call? call) async {
    if(call != null) {
      var result = await call.get();
      UserInfo userInfo = call.state.value.otherParticipants.map((e) => e.toUserInfo()).toList()[0];

      ActiveCallResponse activeCallResponse = ActiveCallResponse(
          name: userInfo.name,
          avatar: userInfo.image ?? Media.light,
          user: userInfo.id,
          channel: call.callCid.id,
          type: call.type.value.toLowerCase() == "voice" ? CallType.voice : CallType.tip2fix,
          isCaller: userInfo.id == call.state.value.localParticipant?.userId,
          app: "",
          status: call.state.value.status.isIncoming ? status.CallStatus.ringing : status.CallStatus.onCall,
          category: result.isSuccess ? result.getDataOrNull()?.metadata.details.custom["category"].toString() ?? "" : "",
          image: result.isSuccess ? result.getDataOrNull()?.metadata.details.custom["image"].toString() ?? "" : "",
          session: 0,
          snt: "CALL"
      );

      if(!Get.currentRoute.startsWith(CallLayout.route)) {
        Navigate.offTill(
          CallLayout.route,
          ModalRoute.withName(HomeLayout.route),
          parameters: {"user": activeCallResponse.user, "type": activeCallResponse.type.type},
          arguments: {"call": activeCallResponse.toJson(), "start": false, "stream": call}
        );
      }
    } else {
      return;
    }
  }

  void _observeCallKitEvents() {
    _callKitEventSubscriptions.addAll([
      client.onCallKitEvent<ActionCallAccept>(_onCallAccept),
      client.onCallKitEvent<ActionCallDecline>(_onCallDecline),
      client.onCallKitEvent<ActionCallEnded>(_onCallEnded),
      client.onCallKitEvent<ActionCallIncoming>(_onCallIncoming),
    ]);
  }

  void _onCallAccept(ActionCallAccept event) async {
    final uuid = event.data.uuid;
    final cid = event.data.callCid;
    if (uuid == null || cid == null) return;

    final call = await client.consumeIncomingCall(uuid: uuid, cid: cid);
    final callToJoin = call.getDataOrNull();
    if (callToJoin == null) return;

    var acceptResult = await callToJoin.accept();

    // Return if cannot accept call
    if(acceptResult.isFailure) {
      notify.error(message: "Error occurred while accepting call");
      CrashlyticsEngine.logError(acceptResult.getErrorOrNull()?.message.toString() ?? acceptResult.toString(), "ACCEPT CALL CONFIGURATION");
      log('Error accepting call: $call');
      return;
    }

    socket.send(destination: "/call/answer", message: {
      "channel": callToJoin.callCid.id,
    });
    _onNavigateToCall(callToJoin);
  }

  void _onCallDecline(ActionCallDecline event) async {
    final uuid = event.data.uuid;
    final cid = event.data.callCid;
    if (uuid == null || cid == null) return;

    final call = await client.consumeIncomingCall(uuid: uuid, cid: cid);
    final callToReject = call.getDataOrNull();
    if (callToReject == null) return;

    final result = await callToReject.reject(reason: CallRejectReason.decline());
    _endAllCalls();
    if (result is Failure) {
      notify.error(message: "Error occurred while rejecting call");
      CrashlyticsEngine.logError(result.getErrorOrNull()?.message.toString() ?? result.error.message, "REJECT CALL CONFIGURATION");
      log('Error rejecting call: ${result.error}');
    }

    socket.send(destination: "/call/update", message: {
      "channel": callToReject.callCid.id,
      "status": status.CallStatus.declined.value
    });
    _disposeEngines(callToReject.callCid.id);
  }

  void _onCallEnded(ActionCallEnded event) async {
    final uuid = event.data.uuid;
    final cid = event.data.callCid;
    if (uuid == null || cid == null) return;

    final call = client.activeCall;
    if (call == null || call.callCid.value != cid) return;

    final result = await call.leave();
    if (result is Failure) {
      notify.error(message: "Error occurred while ending call");
      CrashlyticsEngine.logError(result.getErrorOrNull()?.message.toString() ?? result.error.message, "END CALL CONFIGURATION");
      log('Error leaving call: ${result.error}');
    }

    socket.send(destination: "/call/end", message: {
      "channel": call.callCid.id
    });
    _disposeEngines(call.callCid.id);
  }

  void _disposeEngines(String channel) {
    HomeController.data.event.removeCallEventByChannel(channel);
    _endAllCalls();
    if(Get.isRegistered<CallController>()) {
      Get.delete<CallController>(force: true);
    }

    Navigate.till(ModalRoute.withName(HomeLayout.route));
  }

  @override
  void onClose() {
    _callKitEventSubscriptions.cancelAll();
    super.onClose();
  }

  void _onCallIncoming(ActionCallIncoming event) async {
    final uuid = event.data.uuid;
    final cid = event.data.callCid;
    if (uuid == null || cid == null) return;

    final call = await client.consumeIncomingCall(uuid: uuid, cid: cid);
    final incomingCall = call.getDataOrNull();
    if (incomingCall == null) return;

    _onNavigateToCall(incomingCall);
  }
}

extension on AuthResponse {
  UserInfo toUserInfo() {
    return UserInfo(
      id: id,
      role: role,
      name: name,
      image: avatar,
    );
  }
}

extension on Subscriptions {
  void addAll<T>(Iterable<StreamSubscription<T>?> subscriptions) {
    for (var i = 0; i < subscriptions.length; i++) {
      final subscription = subscriptions.elementAt(i);
      if (subscription == null) continue;

      add(i + 100, subscription);
    }
  }
}