
import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PrivacyAndSecurityController extends GetxController {
  PrivacyAndSecurityController();
  static PrivacyAndSecurityController get data => Get.find<PrivacyAndSecurityController>();

  final state = PrivacyAndSecurityState();

  final ConnectService _connect = Connect();

  @override
  void onInit() {
    _checkLocationPermission();
    _checkStoragePermission();
    _checkAudioPermission();
    _checkCameraPermission();
    _checkContactPermission();
    _checkNotificationPermission();

    fetchPasswordLastUpdatedAt();

    super.onInit();
  }

  void fetchPasswordLastUpdatedAt() async {
    var response = await _connect.get(endpoint: "/account/password");
    if(response.isOk) {
      state.passwordLastUpdatedAt.value = response.data;
    }
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

  void _checkContactPermission() async {
    if(await Permission.contacts.isGranted){
      state.isContactGranted.value = true;
    } else {
      state.isContactGranted.value = false;
    }
  }

  void _checkAudioPermission() async {
    if(await Permission.microphone.isGranted){
      state.isMicrophoneGranted.value = true;
    } else {
      state.isMicrophoneGranted.value = false;
    }
  }

  void _checkCameraPermission() async {
    if(await Permission.camera.isGranted){
      state.isCameraGranted.value = true;
    } else {
      state.isCameraGranted.value = false;
    }
  }

  List<ButtonView> tabs(String lastUpdatedAt) => [
    if(PlatformEngine.instance.isMobile) ...[
      ButtonView(
        header: "Biometrics",
        body: "Protect your account with your fingerprint",
        icon: Icons.fingerprint_rounded,
        index: 0,
        path: BiometricsLayout.route
      ),
    ],
    ButtonView(
      header: "Two-Factor Authentication",
      body: "Protect your account with your multi-factor authentication",
      icon: Icons.security_rounded,
      index: 1,
      path: MultiFactorLayout.route
    ),
    ButtonView(
      header: "Password",
      body: "Last Changed: $lastUpdatedAt",
      icon: Icons.password_rounded,
      index: 2,
      path: ChangePasswordLayout.route
    ),
  ];

  List<ButtonView> permissions = [
    ButtonView(
      header: "Location",
      body: "Permission Level: Very important",
      icon: Icons.location_pin,
      index: 0,
    ),
    if(PlatformEngine.instance.isMobile) ...[
      ButtonView(
        header: "Storage",
        body: "Permission Level: Important",
        icon: Icons.storage_rounded,
        index: 1,
      ),
    ],
    ButtonView(
      header: "Notification",
      body: "Permission Level: Important",
      icon: Icons.notifications_active_rounded,
      index: 2,
    ),
    ButtonView(
      header: "Contact",
      body: "Permission Level: Important",
      icon: Icons.contacts_rounded,
      index: 3,
    ),
    if(PlatformEngine.instance.isMobile) ...[
      ButtonView(
        header: "Microphone/Audio",
        body: "Permission Level: Needed",
        icon: Icons.mic_rounded,
        index: 4,
      ),
      ButtonView(
        header: "Camera",
        body: "Permission Level: Needed",
        icon: Icons.camera_rounded,
        index: 5,
      ),
    ]
  ];

  bool getPermissionValue(ButtonView tab) => tab.index == 0
      ? state.isLocationGranted.value
      : tab.index == 1
      ? state.isStorageGranted.value
      : tab.index == 2
      ? state.isNotificationGranted.value
      : tab.index == 3
      ? state.isContactGranted.value
      : tab.index == 4
      ? state.isMicrophoneGranted.value
      : state.isCameraGranted.value;

  ButtonView securityLogin() => ButtonView(
    header: "Login Security",
    body: "Select your preferred extra security layer for login",
    icon: Icons.login_rounded,
    index: 5,
    path: state.preference.value.security.type
  );

  void onLoginChanged(Gender gender, ThemeType theme, PreferenceOption preference, ScheduleTime schedule, SecurityType security) {
    state.preference.value = state.preference.value.copyWith(security: security);
    Database.savePreference(state.preference.value);
  }
}