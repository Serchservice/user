import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class EmailSwitchLayout extends GetResponsiveView<EmailSwitchController> {
  static String get route => "/auth/email/switch";

  static void to({required String emailAddress, String referral = ""}) {
    Map<String, String> getParameters() {
      Map<String, String> data = {"email_address": emailAddress};

      if(referral.isNotEmpty) {
        data.putIfAbsent("referral", () => referral);
      }

      return data;
    }

    Navigate.to(route, parameters: getParameters());
  }

  EmailSwitchLayout({super.key});

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
                  GoBack(),
                  SizedBox(height: 20),
                  Obx(() => LineHeader(
                    header: "Hello there,",
                    footer: controller.message,
                    color: Theme.of(context).primaryColor,
                  )),
                  const SizedBox(height: 50),
                  Form(
                    key: controller.formKey,
                    child: Obx(() => Field.password(
                      hintText: "Password",
                      enabled: true,
                      controller: controller.passwordController,
                      keyboard: TextInputType.text,
                      onPressed: () => controller.state.isVisible.toggle(),
                      icon: controller.state.isVisible.value
                        ? Icons.lock_rounded
                        : Icons.lock_open_rounded,
                      obscureText: controller.state.isVisible.value,
                    )),
                  ),
                  const SizedBox(height: 150),
                ]
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() => LoadingButton(
                  text: "Continue as User",
                  buttonColor: Get.theme.primaryColor,
                  borderRadius: 24,
                  textColor: Get.theme.primaryColorLight,
                  onClick: () => controller.becomeAUser(context),
                  loading: controller.state.isVerifying.value
                ))
              ],
            ),
          ],
        ),
      )
    );
  }
}
