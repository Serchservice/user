import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class BecomeAUserSheet extends StatelessWidget {
  final EmailCheckerController controller;

  const BecomeAUserSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      backgroundColor: Get.theme.primaryColorLight,
      padding: EdgeInsets.all(Sizing.space(23)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(Sizing.space(16)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Get.theme.primaryColorDark
              ),
              child: Image.asset(
                Media.logo,
                height: 80,
                color: Get.theme.primaryColorLight,
              ),
            )
          ),
          const SizedBox(height: 40),
          SText.center(
            text: "${controller.emailController.text} was used to start an account creation process as"
            " a Serch provider. If this is you, you can switch the profile to a User",
            color: Get.theme.primaryColor,
          ),
          const SizedBox(height: 40),
          Column(
            children: [
              const SizedBox(height: 20),
              Obx(() => Field.password(
                hintText: "Password",
                enabled: true,
                controller: controller.passwordController,
                keyboard: TextInputType.text,
                onPressed: () => controller.toggle(),
                icon: controller.state.isVisible.value
                  ? Icons.lock_rounded
                  : Icons.lock_open_rounded,
                obscureText: controller.state.isVisible.value,
              )),
            ],
          ),
          const SizedBox(height: 40),
          Obx(() => LoadingButton(
            text: "Continue as User",
            buttonColor: Get.theme.primaryColor,
            borderRadius: 24,
            textColor: Get.theme.primaryColorLight,
            onClick: () => controller.becomeAUser(context),
          ))
        ],
      )
    );
  }
}