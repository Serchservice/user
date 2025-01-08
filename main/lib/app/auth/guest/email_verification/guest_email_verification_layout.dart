import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestEmailVerificationLayout extends GetResponsiveView<GuestEmailVerificationController> {
  static String get route => "/auth/guest/email/verify";

  static void off(GuestEmailVerification data) => Navigate.off(route, parameters: data.toJson());
  static void to(GuestEmailVerification data) => Navigate.to(route, parameters: data.toJson());

  GuestEmailVerificationLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: 10,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: CommonColors.hint, width: 1),
                borderRadius: BorderRadius.circular(16)
              ),
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: Column(
                      spacing: 2,
                      children: [
                        Obx(() => SText(
                          text: controller.state.data.value.name,
                          color: Theme.of(context).primaryColor,
                          size: Sizing.font(14)
                        )),
                        Obx(() => SText(
                          text: controller.state.data.value.emailAddress,
                          color: Theme.of(context).primaryColorLight,
                          size: Sizing.font(12)
                        )),
                      ],
                    ),
                  ),
                  Image.asset(
                    Media.verified,
                    width: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            SText(
              text: "Verify your email address?",
              color: Theme.of(context).primaryColor,
              weight: FontWeight.bold,
              size: Sizing.font(16)
            ),
            SText(
              text: "This makes it easier to switch to user account later.",
              color: Theme.of(context).primaryColor,
              weight: FontWeight.bold,
              size: Sizing.font(12)
            ),
            Expanded(
              child: Image.asset(
                Media.messages,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LoadingButton(
                  text: "Later",
                  borderRadius: 24,
                  textSize: Sizing.font(14),
                  buttonColor: Theme.of(context).scaffoldBackgroundColor,
                  textColor: Theme.of(context).primaryColor,
                  onClick: () => Navigate.all(GuestParentLayout.route),
                ),
                const SizedBox(width: 20),
                Obx(() => LoadingButton(
                  text: "Verify",
                  borderRadius: 24,
                  textSize: Sizing.font(14),
                  onClick: () => controller.send(context),
                  loading: controller.state.isVerifying.value,
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}