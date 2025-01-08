import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RatingLayout extends GetResponsiveView<RatingController> {
  static const String route = "/centre/rating";

  RatingLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.tabs.length,
      child: MainLayout(
        appbar: AppBar(
          elevation: 0.5,
          title: SText.center(
            text: "Rating",
            size: Sizing.font(20),
            weight: FontWeight.bold,
            color: Theme.of(context).primaryColor
          ),
          bottom: TabBar.secondary(
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColorLight,
            unselectedLabelColor: CommonColors.hint,
            dividerColor: Colors.transparent,
            tabs: controller.tabs.map((tab) => Tab(
              text: tab.header,
            )).toList()
          ),
        ),
        child: TabBarView(
          children: [
            RatingSummaryTab(),
            RatingGoodTab(),
            RatingBadTab(),
          ],
        ),
      ),
    );
  }
}