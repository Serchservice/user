import 'dart:io';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:user/library.dart';

const String notifyKey = "snt";

const String chatSNT = "CHAT";
const String callSNT = "CALL";
const String scheduleSNT = "SCHEDULE";
const String tripSNT = "TRIP_MESSAGE";

const String replyMessageKey = 'REPLY';
const String markMessageReadKey = "READ";

const String answerCallKey = "ANSWER_CALL";
const String endCallKey = "END_CALL";
const String declineCallKey = "DECLINE_CALL";

class NotificationBuildImplementation implements NotificationBuildService {
  final MainConfiguration config = MainConfiguration.data;

  int createUniqueId() => DateTime.now().millisecondsSinceEpoch.remainder(100000);

  @override
  void build({required RemoteMessage message, bool isBackground = false, bool shouldNavigate = false}) {
    if(message.notification != null) {
      if(message.data.containsKey(notifyKey) && message.data[notifyKey] == chatSNT) {
        buildChat(isBackground: isBackground, message: message);
      } else if(message.data.containsKey(notifyKey) && message.data[notifyKey] == callSNT) {
        buildCall(isBackground: isBackground, message: message);
      } else if(message.data.containsKey(notifyKey) && message.data[notifyKey] == scheduleSNT) {
        buildSchedule(isBackground: isBackground, message: message);
      } else if(message.data.containsKey(notifyKey) && message.data[notifyKey] == tripSNT) {
        buildConnect(isBackground: isBackground, message: message);
      }
    }
  }

  @override
  void buildCall({required RemoteMessage message, bool isBackground = false}) async {
    if(message.notification != null) {
      NotificationMessage<ActiveCallResponse> notification = NotificationMessage(
          token: message.from ?? "",
          notification: Notification.fromJson(message.notification!.toMap()),
          data: ActiveCallResponse.fromJson(message.data)
      );

      if(notification.data != null) {
        int id = createUniqueId();
        config.addNotification(notification.data!.channel, id);

        NotificationContent content = NotificationContent(
          id: id,
          channelKey: Channel.callKey,
          title: notification.notification.title,
          body: notification.notification.body,
          category: NotificationCategory.Call,
          largeIcon: notification.notification.image,
          wakeUpScreen: true,
          fullScreenIntent: true,
          autoDismissible: false,
          backgroundColor: const Color(0xff050404),
          payload: notification.data?.toStringedJson()
        );

        List<NotificationActionButton> actionButtons = [
          NotificationActionButton(
            key: answerCallKey,
            label: 'Accept',
            actionType: ActionType.Default,
            color: CommonColors.success,
            autoDismissible: true
          ),
          NotificationActionButton(
            key: declineCallKey,
            label: 'Decline',
            actionType: ActionType.SilentAction,
            isDangerousOption: true,
            autoDismissible: true
          ),
        ];

        if(Platform.isAndroid) {
          await AndroidForegroundService.startAndroidForegroundService(
            content: content,
            actionButtons: actionButtons,
            foregroundServiceType: ForegroundServiceType.phoneCall,
            foregroundStartMode: ForegroundStartMode.stick
          );
        } else {
          await AwesomeNotifications().createNotification(
            content: content,
            actionButtons: actionButtons,
            schedule: NotificationInterval(interval: 5)
          );
        }
      }
    }
  }

  @override
  void buildChat({required RemoteMessage message, bool isBackground = false}) async {
    if(message.notification != null) {
      NotificationMessage<ChatNotification> notification = NotificationMessage(
          token: message.from ?? "",
          notification: Notification.fromJson(message.notification!.toMap()),
          data: ChatNotification.fromJson(message.data)
      );

      if(notification.data != null) {
        int id = createUniqueId();
        config.addNotification(notification.data!.room, id);

        if(isBackground) {
          NotificationContent content = NotificationContent(
            id: id,
            channelKey: Channel.chatKey,
            title: notification.notification.title,
            body: notification.notification.body,
            summary: notification.data!.summary,
            showWhen: true,
            wakeUpScreen: true,
            category: NotificationCategory.Message,
            groupKey: notification.data!.room,
            payload: {
              "room": notification.data!.room,
              "id": notification.data!.id,
              "roommate": notification.data!.roommate,
              notifyKey: notification.data!.snt
            },
            roundedLargeIcon: true,
            color: lightAlternateColor,
            largeIcon: notification.data!.image != "" ? notification.data!.image : Media.light,
            notificationLayout: NotificationLayout.Messaging,
          );

          List<NotificationActionButton> actionButtons = [
            NotificationActionButton(
              key: replyMessageKey,
              label: 'Reply',
              requireInputText: true,
              autoDismissible: true,
              color: lightSecondaryTextColor
            ),
            NotificationActionButton(
              key: markMessageReadKey,
              label: 'Mark as read',
              actionType: ActionType.DismissAction,
              color: lightSecondaryTextColor
            ),
          ];
          await AndroidForegroundService.startAndroidForegroundService(
            content: content,
            actionButtons: actionButtons,
            foregroundServiceType: ForegroundServiceType.none,
            foregroundStartMode: ForegroundStartMode.stick
          );
          // await AwesomeNotifications().createNotification(
          //   content: NotificationContent(
          //
          //   ),
          //   actionButtons: [
          //     NotificationActionButton(
          //
          //     ),
          //     NotificationActionButton(
          //
          //     )
          //   ]
          // );
        } else {
          notify.inApp(
            message: notification.notification.body,
            avatar: notification.data!.image,
            name: notification.notification.title,
            onTap: (item) => RouteNavigator.openChat(roommate: notification.data!.roommate)
          );
        }
      }
    }
  }

  @override
  void buildConnect({required RemoteMessage message, bool isBackground = false}) async {
    if(message.notification != null) {
      NotificationMessage<TripNotification> notification = NotificationMessage(
          token: message.from ?? "",
          notification: Notification.fromJson(message.notification!.toMap()),
          data: TripNotification.fromJson(message.data)
      );

      if(notification.data != null) {
        int id = createUniqueId();
        config.addNotification(notification.data!.trip, id);

        if(isBackground) {
          await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: id,
              channelKey: Channel.requestKey,
              title: notification.notification.title,
              body: notification.notification.body,
              showWhen: true,
              wakeUpScreen: true,
              category: NotificationCategory.Message,
              groupKey: notification.data!.trip,
              payload: notification.data!.toStringJson(),
              roundedLargeIcon: true,
              color: lightAlternateColor,
              largeIcon: notification.notification.image ?? Media.light,
              notificationLayout: NotificationLayout.Messaging,
            ),
          );
        } else {
          notify.inApp(
            message: notification.notification.body,
            avatar: notification.notification.image ?? Media.light,
            name: notification.notification.title,
            onTap: (item) {
              if(Database.isUserLoggedIn) {
                Navigate.to(HomeLayout.route);
              } else {
                Navigate.to(GuestHomeLayout.route);
              }
            }
          );
        }
      }
    }
  }

  @override
  void buildRequest({required RemoteMessage message, bool isBackground = false}) async {
    // TODO: implement buildRequest
  }

  @override
  void buildSchedule({required RemoteMessage message, bool isBackground = false}) async {
    if(message.notification != null) {
      NotificationMessage<Schedule> notification = NotificationMessage(
        token: message.from ?? "",
        notification: Notification.fromJson(message.notification!.toMap()),
        data: Schedule.fromJson(message.data)
      );

      if(notification.data != null) {
        int id = createUniqueId();
        config.addNotification(notification.data!.id, id);

        _buildScheduledNotification(notification);

        if(isBackground) {
          await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: id,
              channelKey: Channel.scheduleKey,
              title: notification.notification.title,
              body: notification.notification.body,
              showWhen: true,
              wakeUpScreen: true,
              category: NotificationCategory.Message,
              payload: notification.data?.toStringedJson(),
              roundedLargeIcon: true,
              color: lightAlternateColor,
              largeIcon: notification.data!.image != "" ? notification.data!.image : Media.light,
              notificationLayout: NotificationLayout.Messaging,
            ),
          );
        } else {
          notify.inApp(
            message: notification.notification.body,
            avatar: notification.data!.image,
            name: notification.notification.title,
            onTap: (item) => Navigate.to(HomeLayout.route,)
          );
        }
      }
    }
  }

  void _buildScheduledNotification(NotificationMessage<Schedule> notification) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: Channel.scheduleKey,
        title: "Hello ${Database.auth.firstName}, it's time for that trip you scheduled!",
        body: notification.notification.body,
        summary: "Trip scheduled for ${notification.data!.time}",
        showWhen: true,
        wakeUpScreen: true,
        category: NotificationCategory.Message,
        payload: notification.data?.toStringedJson(),
        roundedLargeIcon: true,
        color: lightAlternateColor,
        largeIcon: notification.data!.image != "" ? notification.data!.image : Media.light,
        notificationLayout: NotificationLayout.Messaging,
      ),
      schedule: NotificationCalendar.fromDate(
        date: CommonUtility.parseScheduleTime(notification.data!.time),
        preciseAlarm: true,
        allowWhileIdle: true,
        repeats: true
      )
    );
  }

  @override
  void buildCallTracker(ActiveCallResponse call) async {
    NotificationMessage<ActiveCallResponse> notification = NotificationMessage(
        token: "",
        notification: Notification(
          title: "Calling (${call.type.type}) - ${call.name}",
          body: "${call.status.type}...",
          image: call.avatar
        ),
        data: call
    );

    int id = createUniqueId();
    config.addNotification(notification.data!.channel, id);

    NotificationContent content = NotificationContent(
      id: id,
      channelKey: Channel.callKey,
      title: notification.notification.title,
      body: notification.notification.body,
      category: NotificationCategory.Call,
      largeIcon: notification.notification.image,
      autoDismissible: false,
      backgroundColor: const Color(0xff050404),
      payload: notification.data?.toStringedJson()
    );

    List<NotificationActionButton> actionButtons = [
      NotificationActionButton(
        key: endCallKey,
        label: 'End',
        actionType: ActionType.DismissAction,
        isDangerousOption: true,
        autoDismissible: true
      ),
    ];

    await AwesomeNotifications().createNotification(
      content: content,
      actionButtons: actionButtons,
      schedule: NotificationInterval(interval: 5)
    );
  }

  @override
  void endCallTracker(ActiveCallResponse call) async {
    int? id = config.findNotification(call.channel);
    if(id != null) {
      // AwesomeNotifications().dismiss(id);
    }
  }

  @override
  void updateCallTracker(ActiveCallResponse call) async {
    int? id = config.findNotification(call.channel);
    if(id != null) {
      NotificationMessage<ActiveCallResponse> notification = NotificationMessage(
          token: "",
          notification: Notification(
              title: "(${call.type.type}) with ${call.name}",
              body: "${call.status.type}...",
              image: call.avatar
          ),
          data: call
      );

      NotificationContent content = NotificationContent(
          id: id,
          channelKey: Channel.callKey,
          title: notification.notification.title,
          body: notification.notification.body,
          category: NotificationCategory.Call,
          largeIcon: notification.notification.image,
          autoDismissible: false,
          backgroundColor: const Color(0xff050404),
          payload: notification.data?.toStringedJson()
      );

      List<NotificationActionButton> actionButtons = [
        NotificationActionButton(
            key: endCallKey,
            label: 'End',
            actionType: ActionType.DismissAction,
            isDangerousOption: true,
            autoDismissible: true
        ),
      ];

      await AwesomeNotifications().createNotification(
          content: content,
          actionButtons: actionButtons,
          schedule: NotificationInterval(interval: 5)
      );
    }
  }
}