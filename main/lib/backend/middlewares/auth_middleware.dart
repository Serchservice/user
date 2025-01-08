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
    if(Database.isUserActive) {
      if(Database.preference.useLastLoggedInAccountAsDefault) {
        return _userNavigation();
      } else if(Database.accounts.isNotEmpty) {
        if(!Database.preference.isAuthenticated) {
          return RouteSettings(name: AccountPickerLayout.route);
        } else {
          return null;
        }
      } else if(Database.isLoggedIn) {
        return _userNavigation();
      } else {
        return _routeAuth();
      }
    } else if(Database.isGuestActive) {
      if(Database.guestPreference.useLastLoggedInAccountAsDefault) {
        return _guestNavigation();
      } else if(Database.accounts.isNotEmpty) {
        return RouteSettings(name: AccountPickerLayout.route);
      } else {
        return _guestNavigation();
      }
    } else {
      return _routeAuth();
    }
  }

  RouteSettings? _userNavigation() {
    if(Database.loginWithBiometrics && !Database.preference.isAuthenticated) {
      return RouteSettings(name: BiometricsAuthLayout.login(Database.preference.hasBiometrics));
    } else if(Database.loginWithMFA && !Database.preference.isAuthenticated) {
      return RouteSettings(name: MfaAuthLayout.loginRoute);
    } else {
      return null;
    }
  }

  RouteSettings? _guestNavigation() {
    if(Database.loginGuestWithBiometrics) {
      return RouteSettings(name: GuestBiometricsAuthLayout.login(Database.guestPreference.hasBiometrics));
    } else {
      return const RouteSettings(name: GuestParentLayout.route);
    }
  }

  RouteSettings _routeAuth() {
    if(PlatformEngine.instance.isWeb) {
      return RouteSettings(name: EmailCheckerLayout.route);
    } else {
      return RouteSettings(name: OnboardingLayout.route);
    }
  }
}