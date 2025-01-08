// import 'package:stream_video_flutter/stream_video_flutter.dart';
// import 'package:stream_video_push_notification/stream_video_push_notification.dart';
// import 'package:stream_video_push_notification/stream_video_push_notification_platform_interface.dart';
// import 'package:user/library.dart';
//
// class CallPushProviderSetup {
//   static StreamVideoPushParams videoPushParams = const StreamVideoPushParams(
//     appName: "Serch",
//     handle: "Serch",
//     ios: IOSParams(iconName: 'IconMask'),
//     android: AndroidParams(
//       isCustomNotification: false,
//       isCustomSmallExNotification: true,
//       isShowCallID: false,
//       isShowLogo: true,
//       backgroundColor: "#ffffff",
//       actionColor: "#050404",
//       textColor: "#050404",
//       incomingCallNotificationChannelName: AppNotificationChannel.callName,
//       isShowFullLockedScreen: true,
//       missedCallNotificationChannelName: AppNotificationChannel.callName,
//       ringtonePath: "res_incoming.mp3"
//     ),
//     textAccept: "Answer",
//     textDecline: "Decline",
//     missedCallNotification: NotificationParams(isShowCallback: false)
//   );
//
//   static StreamVideoPushProvider iosConfig = const StreamVideoPushProvider.apn(
//     name: 'serch-apn',
//   );
//
//   static StreamVideoPushProvider androidConfig = const StreamVideoPushProvider.firebase(
//     name: 'serch-firebase',
//   );
//
//   static PNManagerProvider manager = (CoordinatorClient client, StreamVideo video) {
//     return StreamVideoPushNotificationManager.create(
//       iosPushProvider: iosConfig,
//       androidPushProvider: androidConfig,
//       pushParams: videoPushParams,
//       backgroundVoipCallHandler: backgroundCallHandler,
//       callerCustomizationCallback: ({required String callCid, String? callerHandle, String? callerName}) {
//         return CallerCustomizationResponse(
//           handle: "Serch",
//           name: callerName,
//         );
//       },
//     );
//   };
// }