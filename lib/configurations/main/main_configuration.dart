import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:user/library.dart';

class MainConfiguration extends GetxController {
  MainConfiguration();

  static MainConfiguration get data => Get.find<MainConfiguration>();

  static void bind() {
    try {
      if(!MainConfiguration.data.initialized) {
        Get.put<MainConfiguration>(MainConfiguration());
      }
    } catch (_) {
      Get.put<MainConfiguration>(MainConfiguration());
    }
  }

  final AppService _appService = AppImplementation();

  StreamSubscription<Uri>? _linkSubscription;

  /// List of countries
  RxList<Country> countries = Database.countries.obs;

  /// List of cameras in the device
  RxList<CameraDescription> cameras = RxList.empty();

  /// Current route information
  Rx<Routing> currentRoute = Routing().obs;

  /// List of open notifications
  RxList<Notifier> notifications = <Notifier>[].obs;

  @override
  void onInit() async {
    _linkSubscription = await _appService.initializeDeepLink();
    _appService.buildDeviceInformation(
      onSuccess: (device) {
        Database.saveDevice(device);
      }
    );
    _appService.getCountries(
      onSuccess: (result) {
        if(result.isNotEmpty) {
          countries.value = result;
          Database.saveCountries(result);
        }
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

    super.onInit();
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }

  void updateRoute(Routing? routing) {
    if(routing != null) {
      currentRoute.value = routing;
    }
    Logger.log(routing?.route);
  }

  void addNotification(String id, int notification) {
    Notifier notifier = Notifier(notification: notification, id: id);
    notifications.add(notifier);
  }

  void removeNotification({String? id, int? notification}) {
    List<Notifier> notifiers = notifications;
    if(id != null) {
      notifiers.removeWhere((note) => note.id == id);
      notifications.value = notifiers;
    } else if(notification != null) {
      notifiers.removeWhere((note) => note.notification == notification);
      notifications.value = notifiers;
    }
  }

  int? findNotification(String id) {
    return notifications.firstWhereOrNull((notification) => notification.id == id)?.notification;
  }
}