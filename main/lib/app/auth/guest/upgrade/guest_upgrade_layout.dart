import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestUpgradeLayout extends GetResponsiveView<GuestUpgradeController> {
  static const String route = "/auth/guest/upgrade";

  static void open({required String linkId, required String guestId}) {
    Map<String, String> getParams() {
      Map<String, String> params = <String, String>{};

      if(guestId.isNotEmpty) {
        params.putIfAbsent("guest_id", () => guestId);
      }
      if(linkId.isNotEmpty) {
        params.putIfAbsent("link_id", () => linkId);
      }

      return params;
    }

    Navigate.to(route, parameters: getParams());
  }

  GuestUpgradeLayout({super.key});

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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      SText(
                        text: "Phone Number",
                        size: Sizing.font(11),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      const SizedBox(height: 2),
                      PhoneField(
                        controller: controller.phoneController,
                        onChanged: (value) {
                          controller.state.isoCode.value = value.countryISOCode;
                          controller.state.countryCode.value = value.countryCode;
                        },
                        onCountryChanged: (value) {
                          controller.state.country.value = value.name;
                        },
                      ),
                      const SizedBox(height: 20),
                      Field.password(
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
                      ),
                    ],
                  )
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LoadingButton(
                    text: "Continue",
                    borderRadius: 24,
                    width: MediaQuery.sizeOf(context).width,
                    textSize: Sizing.font(12),
                    buttonColor: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).scaffoldBackgroundColor,
                    onClick: () => controller.becomeAUser(context),
                    loading: controller.state.isLoading.value
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
