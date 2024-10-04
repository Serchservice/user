import 'package:flutter/material.dart';
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
    if(Database.preference.useLastLoggedInAccountAsDefault) {
      if(Database.isUserActive) {
        if(Database.loginWithBiometrics && !Database.preference.isAuthenticated) {
          return RouteSettings(name: "${BiometricsAuthLayout.loginRoute}?login=true&has_biometrics=${Database.preference.hasBiometrics}");
        } else if(Database.loginWithMFA && !Database.preference.isAuthenticated) {
          return RouteSettings(name: MfaAuthLayout.loginRoute);
        } else {
          return null;
        }
      } else if(Database.preference.active.isNotEmpty) {
        return const RouteSettings(name: GuestHomeLayout.route);
      } else {
        return RouteSettings(name: OnboardingLayout.route);
      }
    } else if(Database.accounts.isNotEmpty) {
      if(Database.isUserActive) {
        if(!Database.preference.isAuthenticated) {
          return RouteSettings(name: AccountPickerLayout.route);
        } else {
          return null;
        }
      } else {
        return RouteSettings(name: AccountPickerLayout.route);
      }
    } else if(Database.isLoggedIn) {
      if(Database.loginWithBiometrics && !Database.preference.isAuthenticated) {
        return RouteSettings(name: "${BiometricsAuthLayout.loginRoute}?login=true&has_biometrics=${Database.preference.hasBiometrics}");
      } else if(Database.loginWithMFA && !Database.preference.isAuthenticated) {
        return RouteSettings(name: MfaAuthLayout.loginRoute);
      } else {
        return null;
      }
    } else if(Database.preference.active.isNotEmpty) {
      return const RouteSettings(name: GuestHomeLayout.route);
    } else {
      return RouteSettings(name: OnboardingLayout.route);
    }
  }
}