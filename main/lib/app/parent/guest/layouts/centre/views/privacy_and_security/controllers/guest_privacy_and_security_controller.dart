
import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class GuestPrivacyAndSecurityController extends GetxController {
  GuestPrivacyAndSecurityController();
  static GuestPrivacyAndSecurityController get data => Get.find<GuestPrivacyAndSecurityController>();

  final state = GuestPrivacyAndSecurityState();

  @override
  void onInit() {
    _checkLocationPermission();
    _checkStoragePermission();
    _checkCameraPermission();
    _checkNotificationPermission();

    super.onInit();
  }

  void _checkLocationPermission() async {
    var permission = await Geolocator.checkPermission();
    state.isLocationGranted.value = permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  void _checkStoragePermission() async {
    if(PlatformEngine.instance.isAndroid && Database.device.sdk >= 33) {
      if(await Permission.photos.isGranted || await Permission.videos.isGranted
      && await Permission.audio.isGranted && await Permission.manageExternalStorage.isGranted){
        state.isStorageGranted.value = true;
      } else {
        state.isStorageGranted.value = false;
      }
    } else {
      if(await Permission.storage.isGranted){
        state.isStorageGranted.value = true;
      } else {
        state.isStorageGranted.value = false;
      }
    }
  }

  void _checkNotificationPermission() async {
    if(await Permission.notification.isGranted){
      state.isNotificationGranted.value = true;
    } else {
      state.isNotificationGranted.value = false;
    }
  }

  void _checkCameraPermission() async {
    if(await Permission.camera.isGranted){
      state.isCameraGranted.value = true;
    } else {
      state.isCameraGranted.value = false;
    }
  }

  List<ButtonView> tabs = [
    if(PlatformEngine.instance.isMobile) ...[
      ButtonView(
        header: "Biometrics",
        body: "Protect your account with your fingerprint",
        icon: Icons.fingerprint_rounded,
        index: 0,
        path: GuestBiometricsLayout.route
      ),
    ],
  ];

  List<ButtonView> permissions = [
    ButtonView(
      header: "Location",
      body: "Permission Level: Very important",
      icon: Icons.location_pin,
      index: 0,
    ),
    ButtonView(
      header: "Storage",
      body: "Permission Level: Important",
      icon: Icons.storage_rounded,
      index: 1,
    ),
    ButtonView(
      header: "Notification",
      body: "Permission Level: Important",
      icon: Icons.notifications_active_rounded,
      index: 2,
    ),
    ButtonView(
      header: "Camera",
      body: "Permission Level: Needed",
      icon: Icons.camera_rounded,
      index: 5,
    ),
  ];

  bool getPermissionValue(ButtonView tab) => tab.index == 0
      ? state.isLocationGranted.value
      : tab.index == 1
      ? state.isStorageGranted.value
      : tab.index == 2
      ? state.isNotificationGranted.value
      : state.isCameraGranted.value;
}