import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:user/library.dart';

class Channel {
  static const callKey = "Call";
  static const callName = "Call Notification";
  static const callDescription = "Notification for incoming calls (Video, Audio and T2F)";

  static const requestKey = "Request";
  static const requestName = "Request Notification";
  static const requestDescription = "Notification that gives information on the status of a request";

  static const otherKey = "Other";
  static const otherName = "Other Notification";
  static const otherDescription = "Notification for other information";

  static const scheduleKey = "Schedule";
  static const scheduleName = "Schedule Notification";
  static const scheduleDescription = "Notification for scheduled service trips";

  static const chatKey = "Message";
  static const chatName = "Message Notification";
  static const chatDescription = "Notification for messaging";
}

class ChannelGroup {
  static const callKey = "call_key";
  static const callName = "Calls";

  static const otherKey = "others";
  static const otherName = "Others";

  static const chatKey = "chats";
  static const chatName = "Messages";

  static const requestKey = "requests";
  static const requestName = "Trip Requests";
}

class LocalNotificationChannel {
  static List<NotificationChannel> channels = [
    /// [CALL CHANNEL]
    NotificationChannel(
      icon: "resource://raw/res_favicon_dark",
      ledColor: darkBackgroundColor,
      defaultColor: darkBackgroundColor,
      channelGroupKey: ChannelGroup.callKey,
      channelKey: Channel.callKey,
      channelName: Channel.callName,
      channelDescription: Channel.callDescription,
      playSound: true,
      defaultRingtoneType: DefaultRingtoneType.Ringtone,
      soundSource: "resource://raw/res_incoming",
      importance: NotificationImportance.Max,
      channelShowBadge: true,
      locked: true,
    ),

    /// [CHAT CHANNEL]
    NotificationChannel(
      icon: "resource://raw/res_favicon_dark",
      ledColor: darkBackgroundColor,
      defaultColor: darkBackgroundColor,
      channelGroupKey: ChannelGroup.chatKey,
      channelKey: Channel.chatKey,
      channelName: Channel.chatName,
      channelDescription: Channel.chatDescription,
      importance: NotificationImportance.Max,
      channelShowBadge: true,
      playSound: true,
      groupKey: 'grouped chats',
      groupSort: GroupSort.Desc,
      groupAlertBehavior: GroupAlertBehavior.Children,
      vibrationPattern: lowVibrationPattern,
      soundSource: "resource://raw/res_message",
    ),

    /// [SCHEDULE CHANNEL]
    NotificationChannel(
      icon: "resource://raw/res_favicon_dark",
      ledColor: darkBackgroundColor,
      defaultColor: darkBackgroundColor,
      channelGroupKey: ChannelGroup.requestKey,
      channelKey: Channel.scheduleKey,
      channelName: Channel.scheduleName,
      channelDescription: Channel.scheduleDescription,
      importance: NotificationImportance.High,
      channelShowBadge: true,
      playSound: true,
      criticalAlerts: true,
      defaultRingtoneType: DefaultRingtoneType.Alarm,
      soundSource: "resource://raw/res_schedule",
      enableLights: true,
    ),

    /// [REQUEST CHANNEL]
    NotificationChannel(
      icon: "resource://raw/res_favicon_dark",
      ledColor: darkBackgroundColor,
      defaultColor: darkBackgroundColor,
      channelGroupKey: ChannelGroup.requestKey,
      channelKey: Channel.requestKey,
      channelName: Channel.requestName,
      channelDescription: Channel.requestDescription,
      importance: NotificationImportance.High,
      channelShowBadge: true,
      playSound: true,
      soundSource: "resource://raw/res_connect",
      enableLights: true,
      criticalAlerts: true,
      vibrationPattern: mediumVibrationPattern
    ),

    /// [OTHER CHANNEL]
    NotificationChannel(
      channelGroupKey: ChannelGroup.otherKey,
      channelKey: Channel.otherKey,
      channelName: Channel.otherName,
      channelDescription: Channel.otherDescription,
      importance: NotificationImportance.High,
      channelShowBadge: true,
      playSound: true,
      ledColor: darkBackgroundColor,
      defaultColor: darkBackgroundColor,
      soundSource: "resource://raw/res_notify",
      defaultPrivacy: NotificationPrivacy.Public,
    ),
  ];

  // / This contains the different channel groups
  static List<NotificationChannelGroup> groups = [
    /// [CALL CHANNEL GROUP]
    NotificationChannelGroup(
        channelGroupKey: ChannelGroup.callKey,
        channelGroupName: ChannelGroup.callName
    ),

    /// [CHAT CHANNEL GROUP]
    NotificationChannelGroup(
        channelGroupKey: ChannelGroup.chatKey,
        channelGroupName: ChannelGroup.chatName
    ),

    /// [REQUEST CHANNEL GROUP]
    NotificationChannelGroup(
        channelGroupKey: ChannelGroup.requestKey,
        channelGroupName: ChannelGroup.requestName
    ),

    /// [OTHER CHANNEL GROUP]
    NotificationChannelGroup(
        channelGroupKey: ChannelGroup.otherKey,
        channelGroupName: ChannelGroup.otherName
    ),
  ];
}