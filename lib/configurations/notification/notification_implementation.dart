import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:user/library.dart';

class NotificationImplementation implements NotificationService {
  final FirebaseMessagingService _firebaseService = FirebaseMessagingImplementation();
  static final MainConfiguration config = MainConfiguration.data;

  ReceivedAction? initialAction;
  static ReceivePort? receivePort;

  @override
  void init() async {
    initPort();

    AwesomeNotifications().initialize(
      "resource://raw/res_favicon_dark",
      LocalNotificationChannel.channels,
      channelGroups: LocalNotificationChannel.groups,
      debug: true
    );
    _firebaseService.foreground();

    AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod
    );

    initialAction = await AwesomeNotifications().getInitialNotificationAction();

    _firebaseService.foreground();
  }

  @override
  void initPort() {
    try {
      receivePort = ReceivePort('Notification action port in main isolate')
        ..listen((silentData) => onActionReceivedImplementationMethod(silentData));
      receivePort!.listen((serializedData) {
        final receivedAction = ReceivedAction().fromMap(serializedData);
        onActionReceivedImplementationMethod(receivedAction);
      });

      // This initialization only happens on main isolate
      IsolateNameServer.registerPortWithName(receivePort!.sendPort, 'notification_action_port');
    } catch (_) { }
  }

  @pragma("vm:entry-point")
  static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    log(receivedNotification.toMap(), from: "Notification Created");
  }

  @pragma("vm:entry-point")
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    log(receivedNotification.toMap(), from: "Notification Displayed");
  }

  @pragma("vm:entry-point")
  static Future <void> onDismissActionReceivedMethod(ReceivedAction action) async {
    if (Platform.isIOS) {
      AwesomeNotifications().getGlobalBadgeCounter()
          .then((value) => AwesomeNotifications().setGlobalBadgeCounter(value - 1),
      );
    }

    switch(action.channelKey) {
      case Channel.chatKey:
        await onChatDismissed(action);
        break;
      case Channel.callKey:
        await onCallEnded(action);
        break;
    }
  }

  static Future<void> onChatDismissed(ReceivedAction action) async {
    if(action.payload != null && action.payload!.containsKey(notifyKey) && action.payload![notifyKey] == chatSNT) {
      config.removeNotification(notification: action.id, id: action.payload!["room"]);

      if(action.buttonKeyPressed == markMessageReadKey) {
        if(socket.stompClient.connected) {
          Map<String, dynamic> update = {
            "room": action.payload!["room"],
            "status": "READ",
          };
          socket.send(destination: "/chat/update/all", message: update);
          return;
        }
        return;
      }
      return;
    }
  }

  static Future<void> onCallEnded(ReceivedAction action) async {
    if(action.payload != null && action.payload!.containsKey(notifyKey) && action.payload![notifyKey] == callSNT) {
      config.removeNotification(notification: action.id, id: action.payload!["channel"]);

      ActiveCallResponse call = ActiveCallResponse.fromStringedJson(action.payload!);
      if(action.buttonKeyPressed == endCallKey) {
        if(call.isCalling) {
          /// Call endpoint to end call that is not in a ringing state
          socket.send(destination: "/call/update", message: {
            "channel": call.channel,
            "status": CallStatus.missed.value
          });
        } else {
          socket.send(destination: "/call/end", message: {
            "channel": call.channel
          });
        }
        return;
      }
      return;
    }
  }

  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction action) async {
    log(action.toMap(), from: "Action Received");

    if (receivePort == null) {
      SendPort? sendPort = IsolateNameServer.lookupPortByName('notification_action_port');

      if (sendPort != null) {
        sendPort.send(action);
        return;
      }
    }

    switch(action.channelKey) {
      case Channel.chatKey:
        await onChatReply(action);
        break;
      case Channel.callKey:
        await onCallAction(action);
        break;
      default:
        await onActionReceivedImplementationMethod(action);
        break;
    }
  }

  static Future<void> onChatReply(ReceivedAction action) async {
    if(action.payload != null && action.payload!.containsKey(notifyKey) && action.payload![notifyKey] == chatSNT) {
      if(action.buttonKeyInput.isNotEmpty && action.buttonKeyPressed == replyMessageKey) {
        Map<String, dynamic> message = {
          "room": action.payload!["room"],
          "message": action.buttonKeyInput.trim(),
          "type": "TEXT",
        };
        socket.send(destination: "/chat/send", message: message);
        config.removeNotification(notification: action.id, id: action.payload!["room"]);

        int? id = action.id ?? config.findNotification(action.payload!["room"] ?? "");
        if(id != null) {
          AwesomeNotifications().dismiss(id);
        }
        return;
      }
    }
    return onActionReceivedImplementationMethod(action);
  }

  static Future<void> onCallAction(ReceivedAction action) async {
    if(action.payload != null && action.payload!.containsKey(notifyKey) && action.payload![notifyKey] == callSNT) {
      ActiveCallResponse call = ActiveCallResponse.fromStringedJson(action.payload!);
      if(action.buttonKeyPressed == declineCallKey) {
        config.removeNotification(notification: action.id, id: action.payload!["channel"]);
        socket.send(destination: "/call/decline", message: {
          "channel": call.channel
        });
        return;
      }
    }
    return onActionReceivedImplementationMethod(action);
  }

  static Future<void> onActionReceivedImplementationMethod(ReceivedAction action) async {
    WidgetsFlutterBinding.ensureInitialized();

    if(action.payload != null && action.payload!.containsKey(notifyKey) && action.payload![notifyKey] == chatSNT) {
      config.removeNotification(notification: action.id, id: action.payload!["room"]);
      RouteNavigator.openChat(roommate: action.payload!["roommate"] ?? "");
    } else if(action.payload != null && action.payload!.containsKey(notifyKey) && action.payload![notifyKey] == callSNT) {
      ActiveCallResponse call = ActiveCallResponse.fromStringedJson(action.payload!);
      if(action.buttonKeyPressed == answerCallKey) {
        RouteNavigator.answerCall(call: call, removeCurrentRoute: false);
      } else {
        RouteNavigator.goToCall(call: call, removeCurrentRoute: false);
      }
    } else if(action.payload != null && action.payload!.containsKey(notifyKey) && action.payload![notifyKey] == scheduleSNT) {
      Schedule schedule = Schedule.fromStringedJson(action.payload!);
      Navigate.to(HomeLayout.route, arguments: schedule.toJson());
    } else if(action.payload != null && action.payload!.containsKey(notifyKey) && action.payload![notifyKey] == tripSNT) {
      TripNotification trip = TripNotification.fromStringJson(action.payload!);

      if(Database.isUserLoggedIn) {
        Navigate.to(HomeLayout.route, arguments: trip.toJson());
      } else {
        Navigate.to(GuestHomeLayout.route, arguments: trip.toJson());
      }
    }
  }
}