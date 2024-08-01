import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ChangePasswordLayout extends GetResponsiveView<ChangePasswordController> {
  static const String route = "/centre/privacy-and-security/change-password";
  ChangePasswordLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Password Security",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Sizing.space(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(Sizing.space(12)),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor
                  ),
                  child: Icon(
                    Icons.manage_accounts_rounded,
                    size: 100,
                    color: Theme.of(context).appBarTheme.backgroundColor
                  )
                )
              ),
              const SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(Sizing.space(9)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).appBarTheme.backgroundColor,
                ),
                child: SText(
                  text: "Make sure that your password contains a lowercase, uppercase, special characters"
                    " and a number. Minimum of 8 characters expected.\n\n"
                    "NOTE: Changing your password will cancel any account information request you've made previously.",
                  color: Theme.of(context).primaryColor,
                  size: Sizing.font(14)
                )
              ),
              const SizedBox(height: 40),
              Form(
                key: controller.formkey,
                child: Column(
                  children: [
                    Obx(() => Field.password(
                      hintText: "Current Password",
                      enabled: true,
                      textSize: Sizing.font(15.5),
                      controller: controller.currentPassword,
                      keyboard: TextInputType.visiblePassword,
                      onPressed: () => controller.toggleCurrent(),
                      icon: controller.state.isCurrentVisible.value
                        ? Icons.lock_rounded
                        : Icons.lock_open_rounded,
                      obscureText: controller.state.isCurrentVisible.value,
                      validate: (p1) {
                        if(p1 == null) {
                          return "Current Password cannot be empty";
                        }
                        return null;
                      },
                    )),
                    const SizedBox(height: 20),
                    Obx(() => Field.password(
                      hintText: "New Password",
                      enabled: true,
                      textSize: Sizing.font(15.5),
                      controller: controller.newPassword,
                      keyboard: TextInputType.visiblePassword,
                      onPressed: () => controller.toggleNew(),
                      icon: controller.state.isNewVisible.value
                        ? Icons.lock_rounded
                        : Icons.lock_open_rounded,
                      obscureText: controller.state.isNewVisible.value,
                      validate: (p1) {
                        if(p1 == null) {
                          return "New Password cannot be empty";
                        }
                        return null;
                      },
                    )),
                    const SizedBox(height: 20),
                    Obx(() => Field.password(
                      hintText: "Confirm New Password",
                      enabled: true,
                      textSize: Sizing.font(15.5),
                      controller: controller.confirmPassword,
                      keyboard: TextInputType.visiblePassword,
                      onPressed: () => controller.toggleConfirm(),
                      icon: controller.state.isConfirmVisible.value
                        ? Icons.lock_rounded
                        : Icons.lock_open_rounded,
                      obscureText: controller.state.isConfirmVisible.value,
                      validate: (p1) {
                        if(p1 != controller.newPassword.text) {
                          return "Password does not match";
                        }
                        return null;
                      },
                    )),
                    const SizedBox(height: 50),
                    Obx(() => LoadingButton(
                      text: "Change password",
                      width: MediaQuery.of(context).size.width,
                      borderRadius: 24,
                      textSize: Sizing.font(14),
                      loading: controller.state.isConfirming.value,
                      onClick: () => controller.changePassword(),
                    ))
                  ]
                )
              ),
            ],
          ),
        )
      )
    );
  }
}