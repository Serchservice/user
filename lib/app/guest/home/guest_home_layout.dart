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

    return GetX<GuestHomeController>(
      builder: (controller) {
        return MainLayout(
          theme: controller.state.theme.value,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          bottomNavbar: NavigationBar(
            selectedIndex: controller.state.routeIndex.value,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            onDestinationSelected: (index) => controller.selectRoute(index),
            indicatorColor: Theme.of(context).primaryColorDark,
            destinations: tabs.map((tab) => NavigationDestination(
              icon: Icon(
                tab.icon,
                color: Theme.of(context).primaryColor
              ),
              selectedIcon: Icon(
                tab.active,
                color: Theme.of(context).scaffoldBackgroundColor
              ),
              label: tab.title
            )).toList()
          ),
          floater: controller.state.isMinimized.value ? null : controller.buildEventLayout(),
          floaterPosition: 20,
          floatingButton: controller.state.isMinimized.value && controller.state.events.isNotEmpty
            ? FloatingActionButton(
              onPressed: controller.state.isMinimized.toggle,
              tooltip: "Show active events",
              backgroundColor: CommonColors.success,
              child: const Icon(
                Icons.open_in_full_rounded,
                color: CommonColors.lightTheme
              ),
            )
            : null,
          floatingLocation: FloatingActionButtonLocation.startFloat,
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