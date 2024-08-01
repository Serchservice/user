import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class LaunchInMyCitySheet extends StatelessWidget {
  final LocationCheckerController controller;
  final String place;
  const LaunchInMyCitySheet({super.key, required this.controller, required this.place});

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      padding: EdgeInsets.all(Sizing.space(23)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: Image.asset(Media.notLaunched)),
          Obx(() => SText.center(
            text: controller.state.isContinue.value
              ? "$place You can continue or close the app and follow our launch news."
              : "$place. Notify us about this by clicking the button below.",
            color: Theme.of(context).primaryColor,
            size: Sizing.font(16),
          )),
          const SizedBox(height: 40),
          Obx(() => LoadingButton(
            text: controller.state.isContinue.value
              ? "Continue with authentication"
              : "Add my location to the next launch",
            buttonColor: Theme.of(context).primaryColor,
            borderRadius: 24,
            width: MediaQuery.of(context).size.width,
            textColor: Theme.of(context).scaffoldBackgroundColor,
            loading: controller.state.isLoading.value,
            onClick: () => controller.state.isContinue.value
              ? controller.navigate()
              : controller.requestLaunchInMyLocation(),
          ))
        ],
      )
    );
  }
}