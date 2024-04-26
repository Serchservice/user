import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class AppConfiguration extends GetxController {
  AppConfiguration();
  static AppConfiguration get data => Get.find<AppConfiguration>();
  StreamSubscription<Uri>? _linkSubscription;

  final AppService _appService = AppImplementation();

  @override
  void onInit() async {
    super.onInit();

    _linkSubscription = await _appService.initializeDeepLink();
    _appService.buildDeviceInformation(
      onSuccess: (device) {
        Logger.log(device.toJson());
        /// TODO:: Save device data to local storage
      }
    );

    AppLifeCycle appLifeCycle = AppLifeCycle(
      onForeground: () async { },
      onPaused: () async { },
      onDetached: () async {},
      onInactive: () async { },
      onHidden: () async { }
    );
    WidgetsBinding.instance.addObserver(appLifeCycle);
    appLifeCycle.init();
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }
}