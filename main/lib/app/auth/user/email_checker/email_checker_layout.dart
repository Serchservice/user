import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class EmailCheckerLayout extends GetResponsiveView<EmailCheckerController> {
  static const String route = "/auth/email/check";

  static void all({String referral = ""}) {
    Navigate.all(route, parameters: referral.isNotEmpty ? {"referral": referral} : null);
  }

  static void to({String referral = ""}) {
    Navigate.to(route, parameters: referral.isNotEmpty ? {"referral": referral} : null);
  }

  static void off({String referral = ""}) {
    Navigate.off(route, parameters: referral.isNotEmpty ? {"referral": referral} : null);
  }

  EmailCheckerLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: AuthLayout(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(Sizing.space(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LineHeader(
                    header: "Welcome,",
                    footer: "Kickstart your authentication with your email address",
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 50),
                  Form(
                    key: controller.formKey,
                    child: Field(
                      hintText: "Email Address",
                      enabled: true,
                      textSize: Sizing.font(15),
                      controller: controller.emailController,
                      inputAction: TextInputAction.done,
                      keyboard: TextInputType.emailAddress,
                      validate: (p1) {
                        if(p1 != null && !GetUtils.isEmail(p1)) {
                          return "Input a valid email address";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => GuestLoginLayout.to(),
                    child: SText(
                      text: "Have a guest account? Login",
                      color: Theme.of(context).primaryColor,
                      size: Sizing.font(14),
                      weight: FontWeight.bold
                    )
                  ),
                  const SizedBox(height: 150),
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