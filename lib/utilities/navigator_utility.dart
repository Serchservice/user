import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigatorUtility {
  static Future<void> callNumber(String phoneNumber) async {
    await launchUrl(Uri(scheme: 'tel', path: phoneNumber));
  }

  static Future<void> openLink({Uri? uri, String? url}) async {
    final bool nativeAppLaunchSucceeded = await launchUrl(
      uri ?? Uri.parse(url!),
      mode: LaunchMode.externalNonBrowserApplication
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(uri ?? Uri.parse(url!), mode: LaunchMode.inAppWebView,);
    }
  }

  static Future<void> mail(String mailAddress) async {
    await launchUrl(Uri(scheme: "mailto", path: mailAddress));
  }

  static void bottomSheet({
    required Widget sheet,
    required String route,
    Object? arguments,
    Color background = Colors.transparent
  }) {
    Get.bottomSheet(
      sheet,
      backgroundColor: background,
      isScrollControlled: true,
      settings: RouteSettings(name: route, arguments: arguments)
    );
  }

  /// TODO:: Add call and chat router
}