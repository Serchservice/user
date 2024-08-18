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

      return MainLayout(
        appbar: AppBar(
          elevation: 0.5,
          title: SText.center(
            text: title,
            size: Sizing.font(16),
            weight: FontWeight.bold,
            color: Theme.of(context).primaryColor
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(controller.isDisable) ...[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Sizing.font(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SText.center(
                        text: "Are you sure that you want to disable Two-Factor Authentication?",
                        color: Theme.of(context).primaryColor,
                        size: Sizing.font(16),
                        weight: FontWeight.bold,
                      ),
                      const SizedBox(height: 30),
                      Container(
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
                    ],
                  ),
                ),
              ),
            ] else ...[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Sizing.font(16)),
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
                        const SizedBox(height: 15),
                        SText(
                          text: "You can either use recovery code or Google Authenticator Code.",
                          color: Theme.of(context).primaryColor,
                          size: Sizing.font(12),
                          weight: FontWeight.bold,
                        ),
                        const SizedBox(height: 15),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: controller.buttons.length,
                            crossAxisSpacing: 8,
                            mainAxisExtent: 30
                          ),
                          shrinkWrap: true,
                          itemCount: controller.buttons.length,
                          itemBuilder: (context, index) {
                            return Obx(() => ButtonSelector(
                              text: controller.buttons[index],
                              selected: controller.state.isRecovery.value,
                              unSelectedBgColor: Theme.of(context).scaffoldBackgroundColor,
                              onTap: (value) => controller.toggle(index),
                              index: index
                            ));
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
            LoadingButton(
              text: "Confirm",
              borderRadius: 24,
              isCircular: true,
              width: MediaQuery.of(context).size.width,
              textSize: Sizing.font(14),
              onClick: () => controller.verify(),
              loading: controller.state.isVerifying.value,
            ),
            const SizedBox(height: 15),
          ],
        )
      );
    });
  }
}
