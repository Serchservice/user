import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestSignupWithUserAccountLayout extends GetResponsiveView<GuestSignupWithUserAccountController> {
  static const String route = "/auth/guest/signup/user";

  static void to({String link = ""}) {
    Map<String, String> getParams() {
      Map<String, String> params = <String, String>{};

      if(link.isNotEmpty) {
        params.putIfAbsent("link", () => link);
      }

      return params;
    }

    Navigate.to(route, parameters: getParams());
  }

  GuestSignupWithUserAccountLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Obx(() {
        bool isVisible = controller.state.isVisible.value;

        return AuthLayout(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: LineHeader(
                  header: "Hello ${Database.auth.firstName}",
                  footer: "Continue with your user account",
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              if(Database.auth.avatar.isEmpty) ...[
                Row(
                  children: [
                    Avatar.large(avatar: controller.state.avatar.value),
                    const SizedBox(width: 20),
                    LoadingButton(
                      onClick: () => controller.changeAvatar(),
                      padding: EdgeInsets.all(Sizing.space(5)),
                      text: "Upload picture"
                    )
                  ],
                )
              ] else ...[
                Center(child: Avatar.large(avatar: Database.auth.avatar))
              ],
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.formKey,
                  child: Field.password(
                    hintText: "Password",
                    enabled: true,
                    textSize: Sizing.font(15),
                    controller: controller.passwordController,
                    keyboard: TextInputType.visiblePassword,
                    inputAction: TextInputAction.done,
                    onPressed: () => controller.state.isVisible.toggle(),
                    icon: !isVisible ? Icons.lock_rounded : Icons.lock_open_rounded,
                    obscureText: !isVisible,
                    validate: (p1) {
                      if(p1 == null) {
                        return "Password cannot be empty";
                      }
                      return null;
                    },
                  )
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LoadingButton(
                    text: "Create",
                    borderRadius: 24,
                    isCircular: false,
                    textSize: Sizing.font(14),
                    loading: controller.state.isVerifying.value,
                    onClick: () => controller.create(context),
                  )
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
