import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

/// ?email_address=:email&name=:name
class ResetPasswordLayout extends GetResponsiveView<ResetPasswordController> {
  static const String route = "/auth/reset/new";
  ResetPasswordLayout({super.key});

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
                    header: "Secure your account",
                    footer: "Create a strong and unique password you can remember",
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 50),
                  Container(
                    padding: EdgeInsets.all(Sizing.space(15)),
                    decoration: BoxDecoration(
                      color: Theme.of(context).bottomAppBarTheme.color,
                      borderRadius: BorderRadius.circular(24)
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.more_horiz_rounded,
                          size: 50,
                          color: Theme.of(context).primaryColorDark
                        ),
                        const SizedBox(height: 10),
                        SText(
                          text: "Password must contain special characters like *!@"
                          "etc, numbers, uppercase and lowercase characters.",
                          size: Sizing.font(14),
                          color: Theme.of(context).primaryColor,
                        ),
                      ]
                    )
                  ),
                  const SizedBox(height: 50),
                  Form(
                    key: controller.formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Field.password(
                          hintText: "New Password",
                          enabled: true,
                          textSize: Sizing.font(15),
                          controller: controller.passwordController,
                          keyboard: TextInputType.visiblePassword,
                          onPressed: () => controller.toggle(),
                          inputAction: TextInputAction.done,
                          icon: controller.state.isVisible.value
                            ? Icons.lock_rounded
                            : Icons.lock_open_rounded,
                          obscureText: controller.state.isVisible.value,
                          validate: (p1) {
                            if(p1 != null && !p1.contains(RegExp(r'[A-Z]'))) {
                              return "Password must contain a capital letter";
                            }
                            if(p1 != null && !p1.contains(RegExp(r'[a-z]'))) {
                              return "Password must contain a small letter";
                            }
                            if(p1 != null && !p1.contains(RegExp(r'[0-9]'))) {
                              return "Password must contain a number";
                            }
                            if(p1 != null && !p1.contains(RegExp(r'[@-Z]'))) {
                              return "Password must contain a special character";
                            }
                            if(p1 != null && p1.length < 6) {
                              return "Password must be a minimum of 6 characters";
                            }
                            if(p1 == null) {
                              return "Password cannot be empty";
                            }
                            return null;
                          },
                        )),
                        const SizedBox(height: 20),
                        Obx(() => Field.password(
                          hintText: "Confirm Password",
                          enabled: true,
                          textSize: Sizing.font(15),
                          controller: controller.confirmPasswordController,
                          keyboard: TextInputType.visiblePassword,
                          onPressed: () => controller.toggle(),
                          inputAction: TextInputAction.done,
                          icon: controller.state.isVisible.value
                            ? Icons.lock_rounded
                            : Icons.lock_open_rounded,
                          obscureText: controller.state.isVisible.value,
                          validate: (p1) {
                            if(p1 != null && p1 != controller.passwordController.text.trim()) {
                              return "Password does not match";
                            }
                            if(p1 == null) {
                              return "Password cannot be empty";
                            }
                            return null;
                          },
                        )),
                      ]
                    ),
                  ),
                ]
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() => LoadingButton(
                  text: "Reset Password",
                  borderRadius: 24,
                  isCircular: false,
                  textSize: Sizing.font(14),
                  loading: controller.state.isVerifying.value,
                  onClick: () => controller.resetPassword(context),
                ))
              ],
            ),
          ],
        ),
      )
    );
  }
}