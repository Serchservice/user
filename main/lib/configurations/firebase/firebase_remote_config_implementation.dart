import 'package:user/library.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigImplementation implements FirebaseRemoteConfigService {
  final remoteConfig = FirebaseRemoteConfig.instance;

  @override
  String getOneSignalId() {
    return remoteConfig.getString("ONESIGNAL_ID");
  }
}