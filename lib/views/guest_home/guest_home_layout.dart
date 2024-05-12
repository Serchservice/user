import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestHomeLayout extends GetResponsiveView<GuestHomeController> {
  static const String route = "/guest/home";
  GuestHomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    List<DynamicIconButtonView> tabs = [
      DynamicIconButtonView(
        icon: Icons.dashboard_outlined,
        active: Icons.dashboard_rounded,
        title: "Home",
        index: 0,
      ),
      DynamicIconButtonView(
        icon: Icons.connect_without_contact_rounded,
        active: Icons.connect_without_contact_rounded,
        title: "Connect",
        index: 1,
      ),
      DynamicIconButtonView(
        icon: Icons.account_circle_outlined,
        active: Icons.account_circle_rounded,
        title: "Centre",
        index: 2,
      ),
    ];
    return GetBuilder<GuestHomeController>(
      builder: (controller) {
        return ViewLayout(
          theme: controller.state.theme.value,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          bottomNavbar: BottomNavigation(
            backgroundColor: Theme.of(context).bottomAppBarTheme.color,
            tabs: tabs,
            onTap: (index) => controller.selectRoute(index),
          ),
          child: IndexedStack(
            index: controller.state.routeIndex.value,
            children: [
              GuestDashboardLayout(),
              GuestConnectionLayout(),
              GuestCentreLayout()
            ],
          )
        );
      }
    );
  }
}