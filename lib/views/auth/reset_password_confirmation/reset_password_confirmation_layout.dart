import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

/// ?email_address=:email&name=:name
class ResetPasswordConfirmationLayout extends GetResponsiveView<ResetPasswordConfirmationController> {
  static const String route = "/auth/reset/confirm";
  ResetPasswordConfirmationLayout({super.key});

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
                    header: "Hi, ${controller.state.name}",
                    footer: "Confirm your password reset request with token sent to you",
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
                            text: "Resend token",
                            prefixIcon: controller.state.isResending.value
                              ? null
                              : Icons.refresh_rounded,
                            textSize: Sizing.font(14),
                            buttonColor: Theme.of(context).scaffoldBackgroundColor,
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
                  text: "Verify token",
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