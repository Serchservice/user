import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:user/library.dart';

class FirebaseMessagingImplementation implements FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final NotificationBuildService _notificationBuilder = NotificationBuildImplementation();
  final ConnectService _connect = Connect(useToken: Database.preference.active != Database.guest.id);

  @override
  void background(RemoteMessage message) async {
    _notificationBuilder.build(message: message, isBackground: true);
  }

  @override
  void foreground() async {
    _messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

    /// BACKGROUND TERMINATED GETTER
    _messaging.getInitialMessage().then((remoteMessage) {
      if(remoteMessage != null) {
        _notificationBuilder.build(message: remoteMessage, shouldNavigate: true);
      }
    }, onError: (error) {
      log(error, from: "FIREBASE MESSAGING LISTENER - B");
    });

    /// FOREGROUND LISTENER
    FirebaseMessaging.onMessage.listen((message) {
      _notificationBuilder.build(message: message);
    }, onError: (error) {
      log(error, from: "FIREBASE MESSAGING LISTENER - F");
    });

    /// BACKGROUND NOT TERMINATED LISTENER
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      _notificationBuilder.build(message: remoteMessage, shouldNavigate: true);
    }, onError: (error) {
      log(error, from: "FIREBASE MESSAGING LISTENER - F");
    });

    /// TOKEN LISTENER
    _messaging.onTokenRefresh.listen((token) async {
      if(Database.preference.active != Database.guest.id) {
        await _connect.patch(endpoint: "/account/fcm/update?token=$token", body: {});
      } else {
        await _connect.patch(endpoint: "/guest/fcm/update?token=$token&guest=${Database.guest.id}", body: {});
      }
    }, onError: (error) {
      log(error, from: "FIREBASE MESSAGING LISTENER - F");
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