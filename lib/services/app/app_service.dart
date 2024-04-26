import 'dart:async';

import 'package:user/library.dart';

abstract class AppService {
  /// Initialize deep linking
  Future<StreamSubscription<Uri>> initializeDeepLink();

  /// Open deep linking
  void openAppLink(Uri uri);

  /// Build device information
  void buildDeviceInformation({required Function(Device device) onSuccess});

  /// Start app
  void start();
}