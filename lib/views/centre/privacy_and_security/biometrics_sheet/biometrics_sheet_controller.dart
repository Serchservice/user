import 'dart:async';

import 'package:flutter_local_auth_invisible/flutter_local_auth_invisible.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class BiometricsSheetController extends GetxController {
  final bool isLogin;
  final bool hasBiometrics;
  final Function(bool)? onAuthenticated;
  BiometricsSheetController({
    required this.isLogin,
    this.hasBiometrics = false,
    this.onAuthenticated
  });
  final state = BiometricsSheetState();

  final CommonApiService _apiService = CommonApi();

  @override
  void onInit() {
    checkForBiometricSensors();
    super.onInit();
  }

  @override
  void onClose() {
    disposeAuth();
    super.onClose();
  }

  static void disposeAuth() async {
    await LocalAuthentication.stopAuthentication();
  }

  void checkForBiometricSensors() async {
    state.sensors.value = await LocalAuthentication.getAvailableBiometrics();
    state.deviceHasBiometrics.value = await LocalAuthentication.canCheckBiometrics
      && state.sensors.isNotEmpty
      && state.sensors.contains(BiometricType.fingerprint);

    launchScanner();
  }

  void launchScanner() async {
    if (!state.deviceHasBiometrics.value) {
      state.message.value = "Device does not have any biometric sensor";
      state.auth.value = BiometricAuthState.none;
      return;
    } else {
      runAuth();
    }
  }

  void runAuth() async {
    await LocalAuthentication.stopAuthentication();
    Future.delayed(const Duration(milliseconds: 300), () => authenticate());
  }

  void authenticate() async {
    try {
      final authenticated = await LocalAuthentication.authenticate(
        localizedReason: "Serch needs your fingerprint",
        useErrorDialogs: false,
        stickyAuth: true
      );
      Logger.log(authenticated);
      if(authenticated) {
        state.auth.value = BiometricAuthState.successful;
        state.message.value = "Fingerprint verified successfully";
        onSuccess.call();
      } else {
        state.auth.value = BiometricAuthState.failed;
        state.message.value = "Fingerprint not verified";
        Future.delayed(const Duration(seconds: 5));
        state.auth.value = BiometricAuthState.none;
        state.message.value = "Place your finger on your sensor to activate";
        runAuth();
      }
    } catch (e) {
      Logger.log(e);
    }
  }

  void onSuccess() {
    if(isLogin) {
      if(Database.preference.hasBiometrics) {
        _apiService.validateSession(
          onSuccess: (success) {
            Navigate.all(HomeLayout.route);
          },
          onError: (error) {
            Navigate.all(EmailCheckerLayout.route);
            SnackBars.top(message: error, type: Snackbar.error);
          }
        );
      } else {
        SnackBars.top(message: "You have not enabled fingerprint for this account", type: Snackbar.error);
        return;
      }
    } else {
      if(hasBiometrics) {
        Database.savePreference(Database.preference.copyWith(hasBiometrics: false));
        onAuthenticated?.call(false);
      } else {
        Database.savePreference(Database.preference.copyWith(hasBiometrics: true));
        onAuthenticated?.call(true);
      }
    }
  }
}