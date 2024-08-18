import 'package:stream_video_push_notification/stream_video_push_notification.dart';
import 'package:user/library.dart';

class CallPushProviderSetup {
  static StreamVideoPushParams videoPushParams = StreamVideoPushParams(
      appName: "Serch",
      ios: const IOSParams(iconName: 'IconMask'),
      android: AndroidParams(
        isCustomNotification: true,
        isCustomSmallExNotification: true,
        isShowLogo: true,
        backgroundColor: Database.preference.isLightTheme ? "#ffffff" : "#050404",
        actionColor: Database.preference.isLightTheme ? "#050404" : "#ffffff",
        textColor: Database.preference.isLightTheme ? "#050404" : "#ffffff",
        incomingCallNotificationChannelName: Channel.callName,
        isShowFullLockedScreen: true,
        missedCallNotificationChannelName: Channel.callName,
        ringtonePath: "res_incoming.mp3"
      ),
    textAccept: "Answer",
    textDecline: "Decline",
    missedCallNotification: const NotificationParams(isShowCallback: false)
  );

  static StreamVideoPushProvider iosConfig = const StreamVideoPushProvider.apn(
    name: 'serch-apn',
  );

  static StreamVideoPushProvider androidConfig = const StreamVideoPushProvider.firebase(
    name: 'serch-firebase',
  );
}