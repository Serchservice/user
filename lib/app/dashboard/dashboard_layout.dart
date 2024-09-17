import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:user/library.dart';

class DashboardLayout extends GetResponsiveView<HomeController> {
  DashboardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    SliverGridDelegateWithFixedCrossAxisCount count({int length = 3}) {
      return SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: length,
          crossAxisSpacing: 8,
          mainAxisExtent: 120,
          mainAxisSpacing: 8
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardHeader(
            name: controller.state.firstName.value,
            image: controller.state.image.value,
            onSerch: () => Navigate.to(AppInformationLayout.route),
            onAccounts: () => AccountPickerLayout.open(
              onGuestSuccess: (guest) => Navigate.all(GuestHomeLayout.route)
            ),
          ),
          const SizedBox(height: 20),
          FakeField(
            onTap: () => Navigate.to(SkillSearchLayout.route),
            searchText: "Search for keywords, skills, services",
            buttonText: "Search"
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SText(
              text: "Quick Actions",
              size: Sizing.font(14),
              color: Theme.of(context).primaryColor
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: count(),
              shrinkWrap: true,
              itemCount: controller.quickActions.length,
              itemBuilder: (context, index) {
                return DashboardCategorySelector(
                  category: controller.quickActions[index],
                  onCategoryPick: (category) => RouteNavigator.openRequestAction(request: category)
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SText(
              text: "Popular Categories",
              size: Sizing.font(14),
              color: Theme.of(context).primaryColor
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Obx(() {
              if(controller.state.isFetchingPopularCategories.value) {
                return LoadingShimmer(
                  content: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: count(),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: CommonColors.shimmerHigh
                        ),
                      );
                    },
                  ),
                );
              } else {
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: count(),
                  shrinkWrap: true,
                  itemCount: controller.state.popularCategories.length,
                  itemBuilder: (context, index) {
                    return Obx(() {
                      return DashboardCategorySelector(
                        category: controller.state.popularCategories[index],
                        onCategoryPick: DashboardCategoryOptionSelector.open
                      );
                    });
                  },
                );
              }
            }),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SText(
              text: "${DateFormat.EEEE().format(DateTime.now())}'s Activity",
              size: Sizing.space(14),
              weight: FontWeight.w700,
              color: Theme.of(context).primaryColorLight
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Obx(() {
              if(controller.state.isFetchingDashboard.value) {
                return LoadingShimmer(
                  content: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: count(length: 2),
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: CommonColors.shimmerHigh
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      runAlignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        {
                          "header": "Total Trips",
                          "key": controller.state.dashboard.value.trip,
                          "icon": Icons.trending_up_rounded
                        },
                        {
                          "header": "Total Shared Trips",
                          "key": controller.state.dashboard.value.shared,
                          "icon": Icons.share_location_rounded
                        },
                        {
                          "header": "Average Rating",
                          "key": controller.state.dashboard.value.rating,
                          "icon": Icons.stars_outlined
                        },
                        {
                          "header": "Total Schedule",
                          "key": controller.state.dashboard.value.schedule,
                          "icon": Icons.calendar_month_outlined
                        }
                      ].map((item) {
                        return _buildDashboard(
                          context: context,
                          content: item["header"] as String,
                          key: item["key"] as String,
                          icon: item["icon"] as IconData,
                          width: Get.width / 2.2
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    _buildDashboard(
                      context: context,
                      content: "Total Earnings",
                      key: controller.state.dashboard.value.earning,
                      image: Media.wallet
                    )
                  ],
                );
              }
            }),
          ),
          const SizedBox(height: 10)
        ]
      ),
    );
  }

  Widget _buildDashboard({
    required BuildContext context,
    required String key,
    required String content,
    IconData? icon,
    String image = "",
    double? width
  }) => Container(
    padding: EdgeInsets.all(Sizing.space(12)),
    width: width ?? Get.width,
    constraints: const BoxConstraints(maxHeight: 100),
    decoration: BoxDecoration(
        color: CommonColors.darkTheme2,
        borderRadius: BorderRadius.circular(16)
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SText(
              text: key,
              size: Sizing.font(20),
              color: CommonColors.lightTheme,
              weight: FontWeight.bold,
            ),
            if(icon != null) ...[
              Icon(
                  icon,
                  color: CommonColors.lightTheme,
                  size: 25
              )
            ]
          ],
        ),
        const SizedBox(height: 14),
        if(image.isNotEmpty) ...[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                    image,
                    width: 30
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: SText(
                      text: content,
                      size: Sizing.font(15),
                      color: CommonColors.lightTheme
                  ),
                ),
              ],
            ),
          )
        ],
        if(image.isEmpty) ...[
          Expanded(
            child: SText(
                text: content,
                size: Sizing.font(15),
                color: CommonColors.lightTheme
            ),
          )
        ]
      ],
    )
  );
}