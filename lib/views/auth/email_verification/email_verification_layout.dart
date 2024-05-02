import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

/// ?email_address=:email&referral=:code
class EmailVerificationLayout extends GetResponsiveView<EmailVerificationController> {
  static const String route = "/auth/email/verify";
  EmailVerificationLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
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
                    header: "Hi there,",
                    footer: "Check your ${controller.state.emailAddress} inbox for verification token",
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 50),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 8,
                      mainAxisExtent: 50
                    ),
                    shrinkWrap: true,
                    itemCount: controller.controllers.length,
                    itemBuilder: (context, index) {
                      return Field(
                        isOTP: true,
                        textSize: Sizing.font(20),
                        keyboard: TextInputType.number,
                        controller: controller.controllers[index],
                        onChanged: (value) {
                          if(controller.controllers[index] == controller.controllers.last && value.length == 1) {
                            FocusScope.of(context).unfocus();
                            controller.verify(context);
                          } else if(value.length == 1){
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      );
                    },
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
                            onClick: () => controller.resend(context),
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
                  onClick: () => controller.verify(context),
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