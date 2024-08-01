import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActivityLayout extends GetResponsiveView<HomeController> {
  ActivityLayout({super.key});

  @override
  Widget build(BuildContext context) {
    List<ButtonView> tabs = [
      ButtonView(
        icon: Icons.chat,
        header: "Active"
      ),
      ButtonView(
        icon: Icons.call_made_rounded,
        header: "Request"
      ),
      ButtonView(
          icon: Icons.call_made_rounded,
          header: "History"
      ),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: MainLayout(
        appbar: AppBar(
          elevation: 0.5,
          title: SText.center(
            text: "Activity",
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
        child: TabBarView(
          children: [
            ActiveActivityTab(controller: controller),
            RequestActivityTab(controller: controller),
            HistoryActivityTab(controller: controller),
          ],
        ),
      ),
    );
  }
}