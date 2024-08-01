import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

/// ?email_address=:email&referral=:code
class EmailVerificationLayout extends GetResponsiveView<EmailVerificationController> {
  static const String route = "/auth/email/verify";
  EmailVerificationLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(Sizing.space(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LineHeader(
                    header: "Hi there,",
                    footer: "Check your ${controller.state.emailAddress} inbox for verification token",
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 50),
                  OtpField(
                    controller: controller.authController,
                    focusNode: controller.authFocusNode,
                    onCompleted: controller.verify,
                    onChanged: (code) => controller.state.otp.value = code,
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
                  const SizedBox(height: 250),
                ]
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() => LoadingButton(
                  text: "Confirm",
                  borderRadius: 24,
                  isCircular: false,
                  textSize: Sizing.font(14),
                  onClick: () => controller.verify(controller.state.otp.value),
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