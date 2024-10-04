import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:connectify_flutter/connectify_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';
import 'package:stream_video_push_notification/stream_video_push_notification_platform_interface.dart';
import 'package:user/library.dart';
import 'package:user/enums/library.dart' as status;

class CallConfiguration extends GetxController {
  final StreamVideo? videoClient;
  final NotificationMessage<CallNotification>? notification;
  CallConfiguration({this.videoClient, this.notification});

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
      StreamVideo.reset();

      client = StreamVideo(
        Keys.streamApiKey,
        user: User(info: Database.auth.toUserInfo()),
        options: const StreamVideoOptions(
          logPriority: Priority.none,
          muteAudioWhenInBackground: true,
          muteVideoWhenInBackground: true,
        ),
        pushNotificationManagerProvider: StreamVideoPushNotificationManager.create(
          iosPushProvider: CallPushProviderSetup.iosConfig,
          androidPushProvider: CallPushProviderSetup.androidConfig,
          pushParams: CallPushProviderSetup.videoPushParams,
          backgroundVoipCallHandler: backgroundCallHandler,
          callerCustomizationCallback: ({required String callCid, String? callerHandle, String? callerName}) {
            return CallerCustomizationResponse(
              handle: "Serch",
              name: callerName,
            );
          },
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
        consumeIncomingCall(uuid: notification?.token, channel: notification?.data?.callCid);
      });
    } else {
      // no-op. If the app is already running we'll handle it via events
    }
  }

  static Future<void> consumeIncomingCall({String? uuid, String? channel}) async {
    if(uuid != null && channel != null) {
      final callResult = await StreamVideo.instance.consumeIncomingCall(uuid: uuid, cid: channel);

      callResult.fold(success: (result) async {
        onNavigateToCall(result.data);
      }, failure: (error) {
        notify.error(message: "Error consuming incoming call");
        CrashlyticsEngine.logError(error.toString(), "CONSUME CALL CONFIGURATION");
      });
    } else {
      final calls = await StreamVideo.instance.pushNotificationManager?.activeCalls();
      if (calls == null || calls.isEmpty) return;

      final callResult = await StreamVideo.instance.consumeIncomingCall(
        uuid: calls.first.uuid!,
        cid: calls.first.callCid!,
      );

      callResult.fold(success: (result) async {
        onNavigateToCall(result.data);
      }, failure: (error) {
        notify.error(message: "Error consuming incoming call");
        CrashlyticsEngine.logError(error.toString(), "CONSUME CALL CONFIGURATION");
      });
    }
  }

  @override
  void onReady() {
    try {
      StreamBackgroundService.init(
        client,
        callNotificationOptionsBuilder: (call) {
          if(call.state.value.status.isDisconnected) {
            return const NotificationOptions();
          } else {
            CallParticipantState? participant = call.state.value.callParticipants
                .where((d) => !d.isLocal).firstOrNull;
            String type = call.type.value.toLowerCase() == "voice" ? "Voice" : "Tip2Fix";

            if(participant != null) {
              return NotificationOptions(
                content: NotificationContent(
                  title: participant.name,
                  text: "$type | ${call.state.value.status.toStatusString()}"
                ),
                avatar: NotificationAvatar(url: participant.image ?? ""),
                useCustomLayout: true
              );
            } else {
              String type = call.type.value.toLowerCase() == "voice" ? "Voice" : "Tip2Fix";

              return NotificationOptions(
                content: NotificationContent(text: "$type | ${call.state.value.status.toStatusString()}"),
                useCustomLayout: true
              );
            }
          }
        },
        onNotificationClick: (call) async => onNavigateToCall(call),
        onButtonClick: (call, button, service) async => onNavigateToCall(call)
      );

      client.state.incomingCall.listen(onNavigateToCall);

      _observeCallKitEvents();
    } catch (e) {
      CrashlyticsEngine.logError(e.toString(), "STREAM BACKGROUND INITIALIZATION - CALL CONFIGURATION");
    }

    super.onReady();
  }

  static void onNavigateToCall(Call? call) async {
    if(call != null) {
      var result = await call.get();
      ActiveCallResponse activeCallResponse = getCallFromStreamCall(
        call: call,
        category: result.getDataOrNull()?.metadata.details.custom["category"].toString(),
        image: result.getDataOrNull()?.metadata.details.custom["image"].toString(),
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
      // client.onCallKitEvent<ActionCallAccept>(_onCallAccept),
      // client.onCallKitEvent<ActionCallDecline>(_onCallDecline),
      // client.onCallKitEvent<ActionCallEnded>(_onCallEnded),
      client.onCallKitEvent<ActionCallIncoming>(_onCallIncoming),
    ]);
  }

  // void _endAllCalls() {
  //   client.pushNotificationManager?.endAllCalls();
  // }
  //
  static void answerCall({String? uuid, String? channel, ActionCallAccept? event}) async {
    if(uuid != null && channel != null) {
      final callResult = await StreamVideo.instance.consumeIncomingCall(uuid: uuid, cid: channel);
      final call = callResult.getDataOrNull();
      if (call == null) return;

      await call.accept().then((v) {
        if(v.isSuccess) {
          socket.send(destination: "/call/answer", message: {
            "channel": call.callCid.id,
          });
          onNavigateToCall(call);
        } else {
          onNavigateToCall(call);
        }
      });
    } else if(event != null) {
      final uuid = event.data.uuid;
      final cid = event.data.callCid;
      if (uuid == null || cid == null) return;

      final callResult = await StreamVideo.instance.consumeIncomingCall(uuid: uuid, cid: cid);
      final call = callResult.getDataOrNull();
      if (call == null) return;

      await call.accept().then((v) {
        if(v.isSuccess) {
          socket.send(destination: "/call/answer", message: {
            "channel": call.callCid.id,
          });
          onNavigateToCall(call);
        } else {
          onNavigateToCall(call);
        }
      });
    }
  }
  //
  static void declineCall({String? uuid, String? channel, ActionCallDecline? event}) async {
    if(uuid != null && channel != null) {
      final callResult = await StreamVideo.instance.consumeIncomingCall(uuid: uuid, cid: channel);
      final call = callResult.getDataOrNull();
      if (call == null) return;
      await call.reject(reason: CallRejectReason.decline()).then((v) {
        if(v.isSuccess) {
          socket.send(destination: "/call/update", message: {
            "channel": call.callCid.id,
            "status": status.CallStatus.declined.value
          });
          disposeEngines(call.callCid.id);
        }
      });
    } else if(event != null) {
      final uuid = event.data.uuid;
      final cid = event.data.callCid;
      if (uuid == null || cid == null) return;

      final callResult = await StreamVideo.instance.consumeIncomingCall(uuid: uuid, cid: cid);
      final call = callResult.getDataOrNull();
      if (call == null) return;
      await call.reject(reason: CallRejectReason.decline()).then((v) {
        if(v.isSuccess) {
          socket.send(destination: "/call/update", message: {
            "channel": call.callCid.id,
            "status": status.CallStatus.declined.value
          });
          disposeEngines(call.callCid.id);
        }
      });
    }
  }
  //
  // void _onCallEnded(ActionCallEnded event) async {
  //   final uuid = event.data.uuid;
  //   final cid = event.data.callCid;
  //   if (uuid == null || cid == null) return;
  //
  //   final call = client.activeCall;
  //   if (call == null || call.callCid.value != cid) return;
  //
  //   _disposeEngines(call.callCid.id);
  // }
  //
  static void disposeEngines(String channel) {
    HomeController.data.event.removeCallEventByChannel(channel);
    MainConfiguration.data.removeNotification(id: channel);
    StreamVideo.instance.pushNotificationManager?.endAllCalls();
    if(Get.isRegistered<CallController>()) {
      Get.delete<CallController>(force: true);
    }

    Navigate.all(HomeLayout.route);
  }

  void _onCallIncoming(ActionCallIncoming event) async {
    final uuid = event.data.uuid;
    final cid = event.data.callCid;
    if (uuid == null || cid == null) return;

    final call = await client.consumeIncomingCall(uuid: uuid, cid: cid);
    final incomingCall = call.getDataOrNull();
    if (incomingCall == null) return;

    onNavigateToCall(incomingCall);
  }

  @override
  void onClose() {
    _callKitEventSubscriptions.cancelAll();
    super.onClose();
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

ActiveCallResponse getCallFromStreamCall({required Call call, String? category, String? image}) {
  UserInfo userInfo = call.state.value.otherParticipants.map((e) => e.toUserInfo()).toList()[0];

  return ActiveCallResponse(
    name: userInfo.name,
    avatar: userInfo.image ?? Media.light,
    user: userInfo.id,
    channel: call.callCid.id,
    type: call.type.value.toLowerCase() == "voice" ? CallType.voice : CallType.tip2fix,
    isCaller: userInfo.id == call.state.value.localParticipant?.userId,
    app: "",
    status: call.state.value.status.isIncoming ? status.CallStatus.ringing : status.CallStatus.onCall,
    category: category ?? "",
    image: image ?? "",
    session: 0,
    snt: "CALL"
  );
}