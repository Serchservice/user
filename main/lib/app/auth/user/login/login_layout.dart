import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class LoginLayout extends GetResponsiveView<LoginController> {
  static const String route = "/auth/login";

  static void to({required String emailAddress, String name = ""}) {
    Map<String, String> getParameters() {
      Map<String, String> data = {"email_address": emailAddress};

      if(name.isNotEmpty) {
        data.putIfAbsent("name", () => name);
      }

      return data;
    }

    Navigate.to(route, parameters: getParameters());
  }

  static void all() => Navigate.to(route);

  LoginLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: AuthLayout(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(Sizing.space(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => LineHeader(
                    header: "Welcome back, ${controller.state.name}",
                    footer: "Confirm your identity with your password",
                    color: Theme.of(context).primaryColor,
                  )),
                  const SizedBox(height: 50),
                  Form(
                    key: controller.formKey,
                    child: Obx(() => Field.password(
                      hintText: "Password",
                      enabled: true,
                      textSize: Sizing.font(15),
                      controller: controller.passwordController,
                      keyboard: TextInputType.visiblePassword,
                      inputAction: TextInputAction.done,
                      onPressed: () => controller.toggle(),
                      icon: controller.state.isVisible.value
                        ? Icons.lock_rounded
                        : Icons.lock_open_rounded,
                      obscureText: controller.state.isVisible.value,
                      validate: (p1) {
                        if(p1 == null) {
                          return "Password cannot be empty";
                        }
                        return null;
                      },
                    ))
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      LoadingButton(
                        text: "Forgot Password?",
                        padding: const EdgeInsets.all(4),
                        buttonColor: Theme.of(context).scaffoldBackgroundColor,
                        textSize: Sizing.font(12),
                        textColor: Theme.of(context).primaryColor,
                        onClick: () => Navigate.offTo(ResetPasswordRequestLayout.route),
                      )
                    ],
                  ),
                  const SizedBox(height: 150),
                ]
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() => LoadingButton(
                  text: "Login",
                  borderRadius: 24,
                  isCircular: false,
                  textSize: Sizing.font(14),
                  loading: controller.state.isVerifying.value,
                  onClick: () => controller.login(context),
                ))
              ],
            ),
          ],
        ),
      )
    );
  }
}