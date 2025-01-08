import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class MfaAuthLayout extends GetResponsiveView<MfaAuthController> {
  MfaAuthLayout({super.key});

  /// Login route = {mode: MfaAuth.login}
  static String get loginRoute => "/auth/login/mfa";

  /// Disable MFA route = {mode: MfaAuth.disable}
  static String get disableRoute => "/centre/privacy-and-security/multi-factor/disable";

  /// Disable MFA route = {mode: MfaAuth.enable}
  static String get enableRoute => "/centre/privacy-and-security/multi-factor/enable";

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String title = controller.isLogin
        ? "Login with Two-Factor"
        : controller.isDisable
          ? "Confirm Two-Factor Removal"
          : "Two-Factor Authentication";

      String description = controller.isDisable
          ? "Are you sure that you want to disable Two-Factor Authentication?"
          : controller.isLogin
          ? "Your security, enhanced and encrypted..."
          : "Enter the passcode from the authenticator app";

      return MainLayout(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(controller.isDisable) ...[
                  GoBack(color: Theme.of(context).primaryColorLight, icon: Icons.arrow_back)
                ] else ...[
                  Image(image: AssetUtility.image(Media.logo), color: Theme.of(context).primaryColor, width: 80)
                ],
                // Image.asset(Media.logo, width: 80, height: 80, color: Theme.of(context).primaryColor),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: LineHeader(
                    header: title,
                    footer: description,
                    headerSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 40),
                if(controller.isDisable) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: SText(
                        text: "This action will most certainly reduce the security level of your account.",
                        color: Theme.of(context).primaryColor,
                        size: Sizing.font(12),
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OtpField(
                          controller: controller.authController,
                          focusNode: controller.authFocusNode,
                          isBox: false,
                          onCompleted: (code) => controller.verify(code: code),
                          onChanged: (code) => controller.state.token.value = code
                        ),
                        if(controller.isLogin) ...[
                          const SizedBox(height: 40),
                          SText(
                            text: "You can either use recovery code or code from your authenticator app.",
                            color: Theme.of(context).primaryColor,
                            size: Sizing.font(12),
                            weight: FontWeight.bold,
                          ),
                          const SizedBox(height: 15),
                          ...controller.buttons.asMap().entries.map((button) {
                            bool selected = button.key == 0 ? controller.state.isRecovery.value : !controller.state.isRecovery.value;

                            return Container(
                              width: MediaQuery.sizeOf(context).width,
                              margin: EdgeInsets.only(top: button.key == controller.buttons.length - 1 ? 6 : 0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Material(
                                  color: selected ? Theme.of(context).primaryColor : Theme.of(context).appBarTheme.backgroundColor,
                                  child: InkWell(
                                    onTap: () => controller.toggle(button.key),
                                    child: Padding(
                                      padding: EdgeInsets.all(Sizing.space(12)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SText(
                                            text: button.value,
                                            color: selected ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).primaryColor,
                                            size: Sizing.font(14),
                                            weight: FontWeight.bold,
                                          ),
                                          SText(
                                            text: selected ? "Selected authentication option" : "Select to use this option",
                                            color: Theme.of(context).primaryColorLight,
                                            size: Sizing.font(12),
                                          ),
                                        ],
                                      )
                                    ),
                                  )
                                ),
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: LoadingButton(
                    text: "Confirm",
                    borderRadius: 24,
                    isCircular: true,
                    width: MediaQuery.sizeOf(context).width,
                    textSize: Sizing.font(14),
                    onClick: () => controller.verify(),
                    loading: controller.state.isVerifying.value,
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        )
      );
    });
  }
}
