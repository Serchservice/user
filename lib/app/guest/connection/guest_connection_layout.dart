import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestConnectionLayout extends GetResponsiveView<GuestHomeController> {
  GuestConnectionLayout({super.key});

  @override
  Widget build(BuildContext context) {
    List<ButtonView> tabs = [
      ButtonView(header: "Active"),
      ButtonView(header: "Request"),
      ButtonView(header: "History"),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: MainLayout(
        appbar: AppBar(
          elevation: 0.5,
          title: SText.center(
            text: "Connection",
            size: Sizing.font(20),
            weight: FontWeight.bold,
            color: Theme.of(context).primaryColor
          ),
          bottom: TabBar.secondary(
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColorLight,
            unselectedLabelColor: CommonColors.hint,
            dividerColor: Colors.transparent,
            tabs: tabs.map((tab) => Tab(
              text: tab.header,
            )).toList()
          ),
        ),
        floatingButton: FloatingActionButton(
          onPressed: GuestActionView.open,
          tooltip: "Invite ${controller.state.guest.value.link.provider.name}",
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          child: Icon(
            Icons.send,
            color: Theme.of(context).primaryColor
          )
        ),
        child: TabBarView(
          children: [
            GuestActiveActivityTab(controller: controller),
            GuestRequestActivityTab(controller: controller),
            GuestHistoryActivityTab(controller: controller),
          ],
        ),
      ),
    );
  }
}