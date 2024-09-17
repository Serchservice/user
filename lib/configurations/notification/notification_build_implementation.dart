import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:user/library.dart';

const String notifyKey = "snt";
const String callNotifyKey = "sender";

const String chatSNT = "CHAT";
const String callSNT = "stream.video";
const String scheduleSNT = "SCHEDULE";
const String tripSNT = "TRIP_MESSAGE";
const String transactionSNT = "TRANSACTION";

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
    if(message.data.containsKey(notifyKey) && message.data[notifyKey] == chatSNT) {
      buildChat(isBackground: isBackground, message: message);
    } else if(message.data.containsKey(notifyKey) && message.data[notifyKey] == scheduleSNT) {
      buildSchedule(isBackground: isBackground, message: message);
    } else if(message.data.containsKey(notifyKey) && message.data[notifyKey] == tripSNT) {
      buildConnect(isBackground: isBackground, message: message);
    } else if(message.data.containsKey(notifyKey) && message.data[notifyKey] == transactionSNT) {
      buildTransaction(isBackground: isBackground, message: message);
    } else if(isCallNotification(message.data)) {
      buildCall(message: message, isBackground: isBackground);
    } else {
      buildOthers(message: message, isBackground: isBackground);
    }
  }

  @override
  void buildChat({required RemoteMessage message, bool isBackground = false}) async {
    Notification note = Notification.fromJson(message.data);
    NotificationMessage<ChatNotification> notification = NotificationMessage(
      token: message.from ?? "",
      notification: note,
      data: ChatNotification.fromJson(note.data)
    );

    if(notification.data != null && config.notifications.isNotEmpty && config.notifications.any((n) => n.id == notification.data!.room)) {
      return;
    } else {
      int id = createUniqueId();
      config.addNotification(notification.data!.room, id);

      if(isBackground || isPhonePreference(Database.preference.chatNotification) || isAllPreference(Database.preference.chatNotification)) {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: Channel.chatKey,
            title: notification.notification.title,
            body: notification.notification.body,
            summary: notification.data!.summary,
            showWhen: true,
            wakeUpScreen: true,
            // category: NotificationCategory.Message,
            groupKey: notification.data!.room,
            payload: {
              "room": notification.data!.room,
              "id": notification.data!.id,
              "roommate": notification.data!.roommate,
              notifyKey: notification.data!.snt
            },
            // roundedLargeIcon: true,
            color: lightAlternateColor,
            // largeIcon: notification.data!.image != "" ? notification.data!.image : Media.light,
            // notificationLayout: NotificationLayout.Messaging,
          ),
          // actionButtons: [
          //   NotificationActionButton(
          //     key: replyMessageKey,
          //     label: 'Reply',
          //     requireInputText: true,
          //     autoDismissible: true,
          //     color: lightSecondaryTextColor
          //   ),
          //   NotificationActionButton(
          //     key: markMessageReadKey,
          //     label: 'Mark as read',
          //     actionType: ActionType.DismissAction,
          //     color: lightSecondaryTextColor
          //   )
          // ]
        );
      } else if(!isBackground && (isInAppPreference(Database.preference.chatNotification) || isAllPreference(Database.preference.chatNotification))) {
        notify.inApp(
            message: notification.notification.body,
            avatar: notification.data!.image,
            name: notification.notification.title,
            onTap: (item) => RouteNavigator.openChat(roommate: notification.data!.roommate)
        );
      }
    }
  }

  static NotificationMessage<CallNotification> getCallNotification(RemoteMessage message) => NotificationMessage(
      token: message.from ?? message.hashCode.toString(),
      notification: Notification.empty(),
      data: CallNotification.fromJson(message.data)
  );

  @override
  void buildCall({required RemoteMessage message, bool isBackground = false}) async {
    NotificationMessage<CallNotification> notification = getCallNotification(message);

    if(notification.data != null && notification.data!.isRinging && config.notifications.isNotEmpty && config.notifications.any((n) => n.id != notification.data!.channel)) {
      int id = createUniqueId();
      config.addNotification(notification.data!.channel, id);

      if(isBackground || isPhonePreference(Database.preference.callNotification) || isAllPreference(Database.preference.callNotification)) {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: Channel.callKey,
            title: notification.data!.notificationTitle,
            body: notification.data!.notificationBody,
            showWhen: true,
            wakeUpScreen: true,
            category: NotificationCategory.Call,
            groupKey: Channel.callKey,
            payload: notification.data!.toCall().toStringedJson(),
            color: lightAlternateColor,
            timeoutAfter: const Duration(seconds: 30)
          ),
          // actionButtons: [
          //   NotificationActionButton(
          //     key: declineCallKey,
          //     label: 'Decline',
          //     autoDismissible: true,
          //     isDangerousOption: true,
          //     color: lightSecondaryTextColor
          //   ),
          //   NotificationActionButton(
          //     key: answerCallKey,
          //     label: 'Answer',
          //     autoDismissible: true,
          //     actionType: ActionType.DismissAction,
          //     color: lightSecondaryTextColor
          //   )
          // ]
        );
      } else if(!isBackground && (isInAppPreference(Database.preference.callNotification) || isAllPreference(Database.preference.callNotification))) {
        notify.inApp(
          message: notification.data!.notificationBody,
          avatar: Database.preference.isLightTheme ? Media.dark : Media.light,
          name: notification.data!.notificationTitle,
          onTap: (item) => RouteNavigator.goToCall(
            removeCurrentRoute: false,
            call: notification.data!.toCall()
          )
        );
      }
    } else if(notification.data != null && notification.data!.isMissed) {
      return;
    }
  }

  @override
  void buildConnect({required RemoteMessage message, bool isBackground = false}) async {
    Notification note = Notification.fromJson(message.data);
    NotificationMessage<TripNotification> notification = NotificationMessage(
      token: message.from ?? "",
      notification: note,
      data: TripNotification.fromJson(note.data)
    );

    if(notification.data != null) {
      int id = createUniqueId();
      config.addNotification(notification.data!.trip, id);

      if(isBackground || isPhonePreference(Database.preference.connectNotification) || isAllPreference(Database.preference.connectNotification)) {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: Channel.requestKey,
            title: notification.notification.title,
            body: notification.notification.body,
            showWhen: true,
            wakeUpScreen: true,
            // category: NotificationCategory.Message,
            groupKey: notification.data!.trip,
            payload: notification.data!.toStringJson(),
            roundedLargeIcon: true,
            color: lightAlternateColor,
            largeIcon: notification.notification.image ?? Media.light,
            // notificationLayout: NotificationLayout.Messaging,
          ),
        );
      } else if(!isBackground && (isInAppPreference(Database.preference.connectNotification) || isAllPreference(Database.preference.connectNotification))) {
        notify.inApp(
          message: notification.notification.body,
          avatar: notification.notification.image ?? Media.light,
          name: notification.notification.title,
          onTap: (item) {
            if(Database.isUserActive) {
              Navigate.to(HomeLayout.route);
            } else {
              Navigate.to(GuestHomeLayout.route);
            }
          }
        );
      }
    }
  }

  @override
  void buildTransaction({required RemoteMessage message, bool isBackground = false}) async {
    Notification note = Notification.fromJson(message.data);
    NotificationMessage<TransactionNotification> notification = NotificationMessage(
        token: message.from ?? "",
        notification: note,
        data: TransactionNotification.fromJson(note.data)
    );

    if(notification.data != null) {
      int id = createUniqueId();
      config.addNotification(notification.data!.hashCode.toString(), id);

      if(isBackground || isPhonePreference(Database.preference.otherNotification) || isAllPreference(Database.preference.otherNotification)) {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: Channel.otherKey,
            title: notification.notification.title,
            body: notification.notification.body,
            showWhen: true,
            wakeUpScreen: true,
            roundedLargeIcon: true,
            color: lightAlternateColor,
          ),
        );
      } else if(!isBackground && (isInAppPreference(Database.preference.otherNotification) || isAllPreference(Database.preference.otherNotification))) {
        notify.inApp(
          message: notification.notification.body,
          avatar: notification.notification.image ?? Media.light,
          name: notification.notification.title,
        );
      }
    }
  }

  @override
  void buildSchedule({required RemoteMessage message, bool isBackground = false}) async {
    Notification note = Notification.fromJson(message.data);
    NotificationMessage<Schedule> notification = NotificationMessage(
        token: message.from ?? "",
        notification: note,
        data: Schedule.fromJson(note.data)
    );

    if(notification.data != null) {
      int id = createUniqueId();
      config.addNotification(notification.data!.id, id);

      _buildScheduledNotification(notification);

      if(isBackground || isPhonePreference(Database.preference.scheduleNotification) || isAllPreference(Database.preference.scheduleNotification)) {
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
      } else if(!isBackground && (isInAppPreference(Database.preference.scheduleNotification) || isAllPreference(Database.preference.scheduleNotification))) {
        notify.inApp(
          message: notification.notification.body,
          avatar: notification.data!.image,
          name: notification.notification.title,
          onTap: (item) => Navigate.to(HomeLayout.route,)
        );
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

    if(isBackground || isPhonePreference(Database.preference.otherNotification) || isAllPreference(Database.preference.otherNotification)) {
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
    } else if(!isBackground && (isInAppPreference(Database.preference.otherNotification) || isAllPreference(Database.preference.otherNotification))) {
      notify.inApp(
          message: message.notification?.body ?? "An important update just occurred with your account.",
          avatar: Media.logoBlack,
          name: message.notification?.title ?? "Update!",
          onTap: (item) => Navigate.to(HomeLayout.route,)
      );
    }
  }
}

bool isCallNotification(Map<String, dynamic> data) => (data.containsKey(callNotifyKey) && data[callNotifyKey] == callSNT)
    || (data.containsKey(notifyKey) && data[notifyKey] == callSNT);