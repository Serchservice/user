import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

/// ?email_address=:email&name=:name
class ResetPasswordConfirmationLayout extends GetResponsiveView<ResetPasswordConfirmationController> {
  static const String route = "/auth/reset/confirm";
  ResetPasswordConfirmationLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(Sizing.space(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LineHeader(
                    header: "Hi, ${controller.state.name}",
                    footer: "Confirm your password reset request with token sent to you",
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
                            text: "Resend token",
                            prefixIcon: controller.state.isResending.value
                              ? null
                              : Icons.refresh_rounded,
                            textSize: Sizing.font(12),
                            buttonColor: Theme.of(context).scaffoldBackgroundColor,
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
                  text: "Verify token",
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