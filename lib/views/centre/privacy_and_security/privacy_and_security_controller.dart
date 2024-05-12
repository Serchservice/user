import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user/library.dart';

class PrivacyAndSecurityController extends GetxController {
  PrivacyAndSecurityController();
  final state = PrivacyAndSecurityState();

  final Connect _connect = Connect();

  @override
  void onInit() {
    checkLocationPermission();
    checkStoragePermission();
    checkAudioPermission();
    checkCameraPermission();
    checkContactPermission();
    checkNotificationPermission();
    fetchPasswordLastUpdatedAt();
    super.onInit();
  }

  void fetchPasswordLastUpdatedAt() async {
    try {
      var res = await _connect.get(endpoint: "/account/password");
      ApiResponse response = ApiResponse.fromJson(res.data);
      if(response.isOk) {
        state.passwordLastUpdatedAt.value = response.data;
      }
    } on Exception catch (_) { }
  }

  void checkLocationPermission() async {
    var permission = await Geolocator.checkPermission();
    state.isLocationGranted.value = permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  void checkStoragePermission() async {
    if(Platform.isAndroid && Database.device.sdk >= 33) {
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

  void checkNotificationPermission() async {
    if(await Permission.notification.isGranted){
      state.isNotificationGranted.value = true;
    } else {
      state.isNotificationGranted.value = false;
    }
  }

  void checkContactPermission() async {
    if(await Permission.contacts.isGranted){
      state.isContactGranted.value = true;
    } else {
      state.isContactGranted.value = false;
    }
  }

  void checkAudioPermission() async {
    if(await Permission.microphone.isGranted){
      state.isMicrophoneGranted.value = true;
    } else {
      state.isMicrophoneGranted.value = false;
    }
  }

  void checkCameraPermission() async {
    if(await Permission.camera.isGranted){
      state.isCameraGranted.value = true;
    } else {
      state.isCameraGranted.value = false;
    }
  }
}