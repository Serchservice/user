import 'dart:async';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:get/get.dart';
import 'package:user/library.dart';

class BiometricsAuthController extends GetxController {
  BiometricsAuthController();
  final state = BiometricsAuthState();

  final LocalAuthentication auth = LocalAuthentication();
  final AuthValidatorService _apiService = AuthValidator();

  final params = Get.parameters;

  @override
  void onInit() {
    state.isLogin.value = bool.parse(params["login"] ?? "false");
    state.hasBiometrics.value = bool.parse(params["has_biometrics"] ?? "${Database.preference.hasBiometrics}");

    _checkForBiometricSensors();
    super.onInit();
  }

  @override
  void onClose() {
    _disposeAuth();
    super.onClose();
  }

  void _disposeAuth() async {
    await auth.stopAuthentication();
  }

  void _checkForBiometricSensors() async {
    state.sensors.value = await auth.getAvailableBiometrics();
    state.deviceHasBiometrics.value = await auth.canCheckBiometrics
        && state.sensors.isNotEmpty;

    _launchScanner();
  }

  void _launchScanner() async {
    if (!state.deviceHasBiometrics.value) {
      state.message.value = "Device does not have any biometric sensor";
      state.auth.value = BiometricAuthState.none;
      return;
    } else {
      _runAuth();
    }
  }

  void _runAuth() async {
    await auth.stopAuthentication();
    Future.delayed(const Duration(milliseconds: 300), () => _authenticate());
  }

  void _authenticate() async {
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
        _onBiometricsSuccess.call();
      } else {
        state.auth.value = BiometricAuthState.failed;
        state.message.value = "Fingerprint not verified";
        Future.delayed(const Duration(seconds: 5));
        state.auth.value = BiometricAuthState.none;
        state.message.value = "Place your finger on your sensor to activate";
        _runAuth();
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
        _runAuth();
      }
    }
  }

  void _onBiometricsSuccess() {
    if(state.isLogin.value) {
      if(Database.preference.hasBiometrics) {
        if(Database.loginWithMFA && !Database.preference.isAuthenticated) {
          Navigate.off(MfaAuthLayout.loginRoute);
        } else {
          _apiService.validateSession(
            onSuccess: (success) {
              Database.savePreference(Database.preference.copyWith(isAuthenticated: true));
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
        _apiService.validateSession(
          onSuccess: (success) {
            Database.savePreference(Database.preference.copyWith(isAuthenticated: true));
            Navigate.all(HomeLayout.route);
          },
          onError: (error) {
            Navigate.all(EmailCheckerLayout.route);
            notify.error(message: error);
          }
        );
      }
    } else {
      if(state.hasBiometrics.value) {
        Database.savePreference(Database.preference.copyWith(hasBiometrics: false));
        Navigate.back(result: false);
      } else {
        Database.savePreference(Database.preference.copyWith(hasBiometrics: true));
        Navigate.back(result: true);
      }
    }
  }
}