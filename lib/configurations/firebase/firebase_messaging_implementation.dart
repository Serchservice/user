import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/instance_manager.dart';
import 'package:user/library.dart';

class FirebaseMessagingImplementation implements FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final NotificationBuildService _notificationBuilder = NotificationBuildImplementation();

  @override
  void background(RemoteMessage message) async {
    await Firebase.initializeApp(options: FirebaseConfiguration.currentPlatform);
    Get.put<MainConfiguration>(MainConfiguration());
    _notificationBuilder.build(message: message, isBackground: true);
  }

  @override
  void foreground() {
    _messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

    /// BACKGROUND TERMINATED GETTER
    _messaging.getInitialMessage().then((remoteMessage) {
      if(remoteMessage != null) {
        _notificationBuilder.build(message: remoteMessage, shouldNavigate: true);
      }
    }, onError: (_) { });

    /// FOREGROUND LISTENER
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      _notificationBuilder.build(message: remoteMessage);
    }, onError: (_) { });

    /// BACKGROUND NOT TERMINATED LISTENER
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      _notificationBuilder.build(message: remoteMessage, shouldNavigate: true);
    });

    /// TOKEN LISTENER
    _messaging.onTokenRefresh.listen((token) async {
      final ConnectService connect = Connect(useToken: Database.preference.active != Database.guest.id);
      if(Database.preference.active != Database.guest.id) {
        await connect.patch(endpoint: "/account/fcm/update?token=$token", body: {});
      } else {
        await connect.patch(endpoint: "/guest/fcm/update?token=$token&guest=${Database.guest.id}", body: {});
      }
    });
  }

  @override
  Future<String> getFcmToken() async {
    try {
      final result = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      do {
        final deviceToken = await _messaging.getToken();
        while (deviceToken != null && deviceToken.isNotEmpty) {
          return deviceToken;
        }
      } while (result.authorizationStatus == AuthorizationStatus.authorized);
      return "";
    } catch (e) {
      return "";
    }
  }
}