import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:user/library.dart';

class RemoteMessagingImplementation implements RemoteMessagingService {
  final _messaging = FirebaseMessaging.instance;

  @override
  void backgroundHandler() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
  }

  @override
  void foregroundHandler() {
    // TODO: implement foregroundHandler
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