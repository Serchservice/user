import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestParentLayout extends GetResponsiveView<GuestParentController> {
  static const String route = "/guest";
  GuestParentLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<GuestParentController>(
      builder: (controller) {
        int current = controller.state.routeIndex.value;

        return MainLayout(
          theme: controller.state.theme.value,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          navigationColor: Theme.of(context).scaffoldBackgroundColor,
          barColor: current == 0 ? Theme.of(context).scaffoldBackgroundColor : null,
          bottomNavbar: NavigationBar(
            selectedIndex: current,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            indicatorShape: CircleBorder(),
            onDestinationSelected: (index) => controller.selectRoute(index),
            indicatorColor: Theme.of(context).primaryColorDark,
            height: 60,
            elevation: 6,
            shadowColor: Theme.of(context).primaryColorDark,
            destinations: controller.tabs.map((tab) => NavigationDestination(
              icon: Icon(tab.icon, color: Theme.of(context).primaryColor),
              selectedIcon: Icon(tab.active, color: Theme.of(context).scaffoldBackgroundColor, size: 18),
              label: tab.title
            )).toList()
          ),
          floater: EventController.data.buildLayout(),
          floaterPosition: 20,
          floatingButton: EventController.data.buildButton(),
          floatingLocation: FloatingActionButtonLocation.startFloat,
          child: IndexedStack(
            index: current,
            children: [
              GuestHomeLayout(),
              ActivityLayout(),
              GuestCentreLayout()
            ],
          )
        );
      }
    );
  }
}