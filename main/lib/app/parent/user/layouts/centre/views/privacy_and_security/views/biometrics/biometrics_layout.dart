import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BiometricsLayout extends GetResponsiveView<BiometricsController> {
  static const String route = "/centre/privacy-and-security/biometrics";

  BiometricsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Biometrics Security",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(Sizing.space(16)),
        child: Column(
          children: [
            Center(
              child: Obx(() => Container(
                  padding: EdgeInsets.all(Sizing.space(12)),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.hasBiometrics ? CommonColors.green : Theme.of(context).primaryColor
                  ),
                  child: Icon(
                    Icons.fingerprint_rounded,
                    size: 100,
                    color: controller.hasBiometrics ? CommonColors.lightTheme : Theme.of(context).appBarTheme.backgroundColor
                  )
                )
              )
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SText(
                text: "Biometrics security enables you to verify your identity whenever you"
                    " leave the platform. This adds an extra layer of security to your account, making it"
                    " private and secure.\n"
                    "REMEMBER: You are responsible for your account security, as we do our best to provide"
                    " all the tools you will need for it.",
                color: Theme.of(context).primaryColor,
                size: Sizing.font(14),
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => LoadingButton(
              text: controller.hasBiometrics ? "Disable" : "Enable",
              width: MediaQuery.sizeOf(context).width,
              onClick: controller.onClick
            ))
          ]
        ),
      )
    );
  }
}