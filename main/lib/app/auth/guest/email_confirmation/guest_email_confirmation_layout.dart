import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestEmailConfirmationLayout extends GetResponsiveView<GuestEmailConfirmationController> {
  static String get route => "/auth/guest/email/confirm";

  static void off(GuestEmailVerification data) => Navigate.off(route, parameters: data.toJson());

  GuestEmailConfirmationLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: AuthLayout(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(Sizing.space(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => LineHeader(
                    header: "Hi there,",
                    footer: "Check your ${controller.state.data.value.emailAddress} inbox for verification token",
                    color: Theme.of(context).primaryColor,
                  )),
                  const SizedBox(height: 50),
                  OtpField(
                    controller: controller.authController,
                    focusNode: controller.focusNode,
                    onCompleted: (code) =>  controller.verify(code: code),
                    onChanged: (code) => controller.state.token.value = code,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Obx(() {
                        if(controller.state.isCounting.value) {
                          return SText(
                            text: "Request another in: ${controller.state.timeout.value} seconds",
                            size: Sizing.font(14),
                            color: Theme.of(context).primaryColor,
                          );
                        } else {
                          return LoadingButton(
                            text: "Resend OTP",
                            textSize: Sizing.font(14),
                            buttonColor: controller.state.isCounting.value
                              ? Theme.of(context).scaffoldBackgroundColor
                              : Theme.of(context).bottomAppBarTheme.color,
                            textColor: Theme.of(context).primaryColor,
                            onClick: () => controller.resend(),
                            loading: controller.state.isResending.value,
                          );
                        }
                      })
                    ],
                  ),
                  const SizedBox(height: 150),
                ]
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20,
              children: [
                LoadingButton(
                  text: "Later",
                  borderRadius: 24,
                  textSize: Sizing.font(14),
                  buttonColor: Theme.of(context).scaffoldBackgroundColor,
                  textColor: Theme.of(context).primaryColor,
                  onClick: () => Navigate.all(GuestParentLayout.route),
                ),
                Obx(() => LoadingButton(
                  text: "Confirm",
                  borderRadius: 24,
                  textSize: Sizing.font(14),
                  onClick: () => controller.verify(),
                  loading: controller.state.isVerifying.value,
                ))
              ],
            ),
          ],
        ),
      )
    );
  }
}