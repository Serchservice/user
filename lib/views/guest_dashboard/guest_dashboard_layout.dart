import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestDashboardLayout extends GetResponsiveView<GuestHomeController> {
  GuestDashboardLayout({super.key});

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
              onUserSuccess: () => Navigate.all(HomeLayout.route),
              onGuestSuccess: () {
                controller.state.firstName.value = Database.guest.firstName;
                controller.state.image.value = Database.guest.avatar;
                controller.state.name.value = Database.guest.name;
                Navigate.back();
              }
            ),
          )
        ]
      )
    );
  }
}