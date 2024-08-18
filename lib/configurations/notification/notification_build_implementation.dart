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
      } else if(message.data.containsKey(notifyKey) && message.data[notifyKey] == scheduleSNT) {
        buildSchedule(isBackground: isBackground, message: message);
      } else if(message.data.containsKey(notifyKey) && message.data[notifyKey] == tripSNT) {
        buildConnect(isBackground: isBackground, message: message);
      } else {
        buildOthers(message: message, isBackground: isBackground);
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
  void buildOthers({required RemoteMessage message, bool isBackground = false}) async {
    int id = createUniqueId();
    config.addNotification(message.hashCode.toString(), id);

    if(isBackground) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: Channel.otherKey,
          title: message.notification?.title,
          body: message.notification?.body,
          showWhen: true,
          wakeUpScreen: true,
          category: NotificationCategory.Message,
          payload: message.data.cast(),
          roundedLargeIcon: true,
          color: lightAlternateColor,
          notificationLayout: NotificationLayout.Messaging,
        ),
      );
    } else {
      notify.inApp(
          message: message.notification?.body ?? "An important update just occurred with your account.",
          avatar: Media.logoBlack,
          name: message.notification?.title ?? "Update!",
          onTap: (item) => Navigate.to(HomeLayout.route,)
      );
    }
  }
}