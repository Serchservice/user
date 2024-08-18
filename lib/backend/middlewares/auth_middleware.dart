import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class AuthMiddleware extends GetMiddleware{
  int? _priority = 0;

  @override
  int? get priority => _priority;

  @override
  set priority(int? value) {
    _priority = value;
  }

  AuthMiddleware({
    required int? priority
  }) : _priority = priority;

  @override
  RouteSettings? redirect(String? route) {
    FlutterNativeSplash.remove();

    if(Database.preference.skipLocationCheck) {
      if(Database.preference.useLastLoggedInAccountAsDefault) {
        if(Database.isUserLoggedIn) {
          if(Database.loginWithBiometrics) {
            return RouteSettings(name: "${BiometricsAuthLayout.loginRoute}?login=true&has_biometrics=${Database.preference.hasBiometrics}");
          } else if(Database.loginWithMFA) {
            return RouteSettings(name: MfaAuthLayout.loginRoute);
          } else {
            return const RouteSettings(name: HomeLayout.route);
          }
        } else if(Database.preference.active.isNotEmpty) {
          return const RouteSettings(name: GuestHomeLayout.route);
        } else {
          return RouteSettings(name: OnboardingLayout.route);
        }
      } else if(Database.accounts.isNotEmpty) {
        return RouteSettings(name: AccountPickerLayout.route);
      } else if(Database.isLoggedIn) {
        if(Database.loginWithBiometrics) {
          return RouteSettings(name: "${BiometricsAuthLayout.loginRoute}?login=true&has_biometrics=${Database.preference.hasBiometrics}");
        } else if(Database.loginWithMFA) {
          return RouteSettings(name: MfaAuthLayout.loginRoute);
        } else {
          return const RouteSettings(name: HomeLayout.route);
        }
      } else if(Database.preference.active.isNotEmpty) {
        return const RouteSettings(name: GuestHomeLayout.route);
      } else {
        return const RouteSettings(name: EmailCheckerLayout.route);
      }
    } else {
      return null;
    }
  }
}