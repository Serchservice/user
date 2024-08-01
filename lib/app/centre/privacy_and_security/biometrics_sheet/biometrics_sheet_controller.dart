import 'dart:async';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
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

  final LocalAuthentication auth = LocalAuthentication();
  final AuthValidatorService _apiService = AuthValidator();

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

  void disposeAuth() async {
    await auth.stopAuthentication();
  }

  void checkForBiometricSensors() async {
    state.sensors.value = await auth.getAvailableBiometrics();
    state.deviceHasBiometrics.value = await auth.canCheckBiometrics
      && state.sensors.isNotEmpty;

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
    await auth.stopAuthentication();
    Future.delayed(const Duration(milliseconds: 300), () => authenticate());
  }

  void authenticate() async {
    try {
      final authenticated = await auth.authenticate(
        localizedReason: "Serch needs your fingerprint",
        options: const AuthenticationOptions(
          useErrorDialogs: false,
          stickyAuth: true,
          biometricOnly: true
        ),
      );
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
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        state.auth.value = BiometricAuthState.failed;
        state.message.value = e.message ?? "Fingerprint not available";
      } else if (e.code == auth_error.notEnrolled) {
        state.auth.value = BiometricAuthState.failed;
        state.message.value = e.message ?? "Fingerprint not enrolled yet";
      } else if (e.code == auth_error.lockedOut) {
        state.auth.value = BiometricAuthState.failed;
        state.message.value = e.message ?? "Locked out. Try again later";
      } else if (e.code == auth_error.permanentlyLockedOut) {
        state.auth.value = BiometricAuthState.failed;
        state.message.value = e.message ?? "Locked out. Try again later";
      } else {
        state.auth.value = BiometricAuthState.failed;
        state.message.value = e.message ?? "Fingerprint not verified";
        Future.delayed(const Duration(seconds: 5));
        state.auth.value = BiometricAuthState.none;
        state.message.value = "Place your finger on your sensor to activate";
        runAuth();
      }
    }
  }

  void onSuccess() {
    if(isLogin) {
      if(Database.preference.hasBiometrics) {
        if(Database.loginWithMFA) {
          AuthWithMultiFactor.login();
        } else {
          _apiService.validateSession(
              onSuccess: (success) {
                Navigate.all(HomeLayout.route);
              },
              onError: (error) {
                Navigate.all(EmailCheckerLayout.route);
                notify.error(message: error);
              }
          );
        }
      } else {
        notify.info(message: "You have not enabled fingerprint for this account");
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