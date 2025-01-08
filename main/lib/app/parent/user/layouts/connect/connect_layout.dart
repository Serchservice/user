import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ConnectLayout extends GetResponsiveView<ConnectController> {
  ConnectLayout({super.key});

  @override
  Widget build(BuildContext context) {
    if(PlatformEngine.instance.isMobile) {
      return DefaultTabController(
        length: controller.tabs.length,
        child: MainLayout(
          appbar: AppBar(
            elevation: 0.5,
            title: SText.center(
              text: "Connect",
              size: Sizing.font(20),
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor
            ),
            actions: [
              InfoButton(onPressed: ConnectNotifier.open)
            ],
            bottom: TabBar.secondary(
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).primaryColorLight,
              unselectedLabelColor: CommonColors.hint,
              dividerColor: Colors.transparent,
              onTap: controller.onTap,
              tabs: controller.tabs.map((tab) => Tab(text: tab.header)).toList()
            ),
          ),
          child: TabBarView(
            children: [
              ChatRoomListLayout(),
              CallChannelListLayout(),
            ],
          ),
        ),
      );
    } else {
      return MainLayout(
        appbar: AppBar(
          elevation: 0.5,
          title: SText.center(
            text: "Chat",
            size: Sizing.font(20),
            weight: FontWeight.bold,
            color: Theme.of(context).primaryColor
          ),
          actions: [
            InfoButton(onPressed: ConnectNotifier.open)
          ],
        ),
        child: ChatRoomListLayout(),
      );
    }
  }
}