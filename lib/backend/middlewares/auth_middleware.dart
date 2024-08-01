import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return null;
  
    // if(GetUserData.isGuestSharing) {
    //   /// There is a guest using the share mode
    //   return const RouteSettings(name: ProvideSharingNavigator.route);
    // } else if(GetUserData.isLoggedIn) {
    //   /// User is logged in
    //   if(GetUserData.isCurrentUserSharing) {
    //     /// Logged in user is in sharing mode
    //     return const RouteSettings(name: SerchAccountModePicker.route);
    //   } else {
    //     /// Logged in user is not in sharing mode
    //     if(GetUserData.profile.hasIssues || GetUserData.profile.isSuspended || GetUserData.profile.isDeactivated) {
    //       /// Logged in user has account issues
    //       return RouteSettings(name: SerchAccountIssues.route);
    //     } else if(GetUserData.setting.tfa) {
    //       /// Logged in user has Two-Factor-Auth
    //       return const RouteSettings(name: SerchRouteNames.auth2FA);
    //     } else if(GetUserData.hasBiometrics) {
    //       /// Logged in User has biometrics
    //       return const RouteSettings(name: SerchRouteNames.loginWithBiometrics);
    //     } else {
    //       /// No security implemented
    //       return const RouteSettings(name: SerchRouteNames.home);
    //     }
    //   }
    // } else {
    //   /// No logged in user
    //   return null;
    // }
  }
}