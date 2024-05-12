import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class DashboardLayout extends GetResponsiveView<HomeController> {
  DashboardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardHeader(
            name: controller.state.firstName.value,
            image: controller.state.image.value,
            onSerch: () => Navigate.to(AppInformationLayout.route),
            onAccounts: () => AccountPicker.open(
              onGuestSuccess: () => Navigate.all(GuestHomeLayout.route)
            ),
          )
        ]
      )
    );
  }
}