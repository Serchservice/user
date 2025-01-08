import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestBiometricsAuthLayout extends GetResponsiveView<GuestBiometricsAuthController> {
  GuestBiometricsAuthLayout({super.key});

  static const String loginRoute = "/guest/auth/login/biometrics";
  static const String route = "/guest/centre/privacy-and-security/biometrics/settings";

  static String login(bool hasBiometrics) {
    return "$loginRoute?login=true&has_biometrics=$hasBiometrics";
  }

  static Future<T?>? to<T>(bool hasBiometrics) {
    return Navigate.to(route, parameters: {"has_biometrics": hasBiometrics.toString()});
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
              child: Image.asset(
              Media.logo,
              width: 100,
              color: Theme.of(context).primaryColor
            )
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => BiometricsAuthIcon(state: controller.state.auth.value)),
                const SizedBox(height: 10),
                Obx(() => SText.center(
                  text: controller.state.message.value,
                  color: BiometricsAuthIcon.getColor(controller.state.auth.value, context),
                )),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Image.asset(
              Media.tagline,
              width: 150,
              color: Theme.of(context).primaryColor
            ),
          ),
        ],
      )
    );
  }
}