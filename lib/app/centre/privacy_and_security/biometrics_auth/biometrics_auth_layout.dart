import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BiometricsAuthLayout extends GetResponsiveView<BiometricsAuthController> {
  BiometricsAuthLayout({super.key});

  /// Login route {login: true, has_biometrics: true}
  static String get loginRoute => "/auth/login/biometrics";

  /// Settings route {login: false, has_biometrics: hasBiometrics}
  static String get route => "/centre/privacy-and-security/biometrics/settings";

  @override
  Widget build(BuildContext context) {
    return MainLayout(
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
                Obx(() => BiometricsIcon(state: controller.state.auth.value)),
                const SizedBox(height: 10),
                Obx(() => SText.center(
                  text: controller.state.message.value,
                  color: getColor(controller.state.auth.value, context),
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

class BiometricsIcon extends StatelessWidget {
  final BiometricAuthState state;
  const BiometricsIcon({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    double iconSize = 60;
    if(state == BiometricAuthState.none) {
      return Icon(
          Icons.fingerprint_rounded,
          color: getColor(state, context),
          size: iconSize
      );
    } else if(state == BiometricAuthState.failed) {
      return Icon(
          Icons.error_rounded,
          color: getColor(state, context),
          size: iconSize
      );
    } else {
      return Icon(
          Icons.check_circle_rounded,
          color: getColor(state, context),
          size: iconSize
      );
    }
  }
}

Color getColor(BiometricAuthState state, BuildContext context) {
  switch(state) {
    case BiometricAuthState.none:
      return Theme.of(context).primaryColorLight;
    case BiometricAuthState.failed:
      return CommonColors.error;
    default:
      return CommonColors.green;
  }
}