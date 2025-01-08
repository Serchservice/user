import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActivityLayout extends GetResponsiveView<ActivityController> {
  ActivityLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.tabs.length,
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
            onTap: controller.onTap,
            tabs: controller.tabs.map((tab) => Tab(
              text: tab.header,
              // child: tab.child,
            )).toList()
          ),
        ),
        child: TabBarView(
          children: [
            ActivityRequestedLayout(),
            ActivityActiveLayout(),
            ActivityHistoryLayout(),
          ],
        ),
      )
    );
  }
}