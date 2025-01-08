import 'package:user/library.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalImplementation implements OneSignalService {
  final FirebaseRemoteConfigService _configService = FirebaseRemoteConfigImplementation();

  @override
  void initialize() {
    if(PlatformEngine.instance.isMobile) {
      OneSignal.initialize(_configService.getOneSignalId());
      OneSignal.Notifications.clearAll();
      OneSignal.LiveActivities.setupDefault();
    }
  }
}