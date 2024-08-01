import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ResetPasswordRequestLayout extends GetResponsiveView<ResetPasswordRequestController> {
  static const String route = "/auth/reset/request";
  ResetPasswordRequestLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(Sizing.space(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LineHeader(
                    header: "Forgot your password?",
                    footer: "Enter your email address for further instructions",
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 50),
                  Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        Field(
                          hintText: "Email Address",
                          enabled: true,
                          textSize: Sizing.font(15),
                          controller: controller.controller,
                          keyboard: TextInputType.emailAddress,
                          inputAction: TextInputAction.done,
                          validate: (p1) {
                            if(p1 != null && !GetUtils.isEmail(p1)) {
                              return "Input a valid email address";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 250),
                ]
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() => LoadingButton(
                  text: "Verify Account",
                  borderRadius: 24,
                  isCircular: false,
                  textSize: Sizing.font(14),
                  loading: controller.state.isVerifying.value,
                  onClick: () => controller.verifyEmail(context),
                ))
              ],
            ),
          ],
        ),
      )
    );
  }
}