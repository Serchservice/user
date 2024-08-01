import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class RatingLayout extends GetResponsiveView<RatingController> {
  static const String route = "/centre/rating";
  RatingLayout({super.key});

  @override
  Widget build(BuildContext context) {
    List<ButtonView> tabs = [
      ButtonView(
        icon: Icons.rate_review_rounded,
        header: "Overview"
      ),
      ButtonView(
        icon: Icons.rate_review_rounded,
        header: "Good Reviews"
      ),
      ButtonView(
        icon: Icons.rate_review_rounded,
        header: "Bad Reviews"
      ),
    ];
    return DefaultTabController(
      length: tabs.length,
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
            tabs: tabs.map((tab) => Tab(
              text: tab.header,
            )).toList()
          ),
        ),
        child: TabBarView(
          children: [
            RatingSummary(controller: controller),
            GoodRating(controller: controller),
            BadRating(controller: controller),
          ],
        ),
      ),
    );
  }
}