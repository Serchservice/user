import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class HomeLayout extends GetResponsiveView<HomeController> {
  static const String route = "/home";
  HomeLayout({super.key});

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
        icon: Icons.category_outlined,
        active: Icons.category_rounded,
        title: "Connect",
        index: 1,
      ),
      DynamicIconButtonView(
        icon: Icons.connect_without_contact_rounded,
        active: Icons.connect_without_contact_rounded,
        title: "Activity",
        index: 2,
      ),
      DynamicIconButtonView(
        icon: Icons.account_circle_outlined,
        active: Icons.account_circle_rounded,
        title: "Centre",
        index: 3,
      ),
    ];

    return GetBuilder<HomeController>(
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
          floater: buildEventLayout(context, controller.state.events),
          child: IndexedStack(
            index: controller.state.routeIndex.value,
            children: [
              DashboardLayout(),
              ConversationLayout(),
              ActivityLayout(),
              CentreLayout()
            ],
          )
        );
      }
    );
  }
}
/// BottomNavigation(
          //   backgroundColor: Theme.of(context).bottomAppBarTheme.color,
          //   tabs: tabs,
          //   onTap: (index) => controller.selectRoute(index),
          // )