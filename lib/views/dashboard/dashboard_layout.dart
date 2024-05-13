import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:user/library.dart';

class DashboardLayout extends GetResponsiveView<HomeController> {
  DashboardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardHeader(
            name: controller.state.firstName.value,
            image: controller.state.image.value,
            onSerch: () => Navigate.to(AppInformationLayout.route),
            onAccounts: () => AccountPicker.open(
              onGuestSuccess: (guest) => Navigate.all(GuestHomeLayout.route)
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Animated(
              toWidget: Container(),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 16.0
                ),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).appBarTheme.backgroundColor
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SText(
                        text: "What skill are you looking for?",
                        size: Sizing.font(14),
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16)
                        ),
                        color: Theme.of(context).primaryColor
                      ),
                      child: SText(
                        text: "Search",
                        size: Sizing.font(14),
                        color: Theme.of(context).scaffoldBackgroundColor
                      ),
                    )
                  ],
                ),
              ),
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
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisExtent: 120
                    ),
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 120,
                    mainAxisSpacing: 8
                  ),
                  shrinkWrap: true,
                  itemCount: controller.state.popularCategories.length,
                  itemBuilder: (context, index) {
                    return Obx(() {
                      return _buildCategoryPicker(
                        context: context,
                        category: controller.state.popularCategories[index]
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
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisExtent: 120,
                      mainAxisSpacing: 8
                    ),
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
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisExtent: 100,
                        mainAxisSpacing: 8
                      ),
                      shrinkWrap: true,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return _buildDashboard(
                          context: context,
                          content: index == 0
                            ? "Total Trips"
                            : index == 1
                            ? "Total Shared Trips"
                            : index == 2
                            ? "Total Rating"
                            : "Total Schedule",
                          key: index == 0
                            ? controller.state.dashboard.value.trip
                            : index == 1
                            ? controller.state.dashboard.value.shared
                            : index == 2
                            ? controller.state.dashboard.value.rating
                            : controller.state.dashboard.value.schedule,
                          icon: index == 0
                            ? Icons.trending_up_rounded
                            : index == 1
                            ? Icons.share_location_rounded
                            : index == 2
                            ? Icons.stars_outlined
                            : Icons.calendar_month_outlined
                        );
                      },
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
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SText(
              text: "What category of service are you looking for today?",
              size: Sizing.font(14),
              color: Theme.of(context).primaryColor
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Obx(() {
              if(controller.state.isFetchingCategories.value) {
                return LoadingShimmer(
                  content: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisExtent: 100
                    ),
                    shrinkWrap: true,
                    itemCount: 8,
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 120,
                    mainAxisSpacing: 8
                  ),
                  shrinkWrap: true,
                  itemCount: controller.state.categories.length,
                  itemBuilder: (context, index) {
                    return Obx(() {
                      return _buildCategoryPicker(
                        context: context,
                        category: controller.state.categories[index]
                      );
                    });
                  },
                );
              }
            }),
          ),
          const SizedBox(height: 20)
        ]
      ),
    );
  }

  ClipRRect _buildCategoryPicker({required BuildContext context, required SerchCategory category}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Expanded(
                  child: CategoryImage(
                    image: category.image,
                    height: 50,
                    width: 80
                  )
                ),
                const SizedBox(height: 4),
                SText.center(
                  text: category.type,
                  size: 9,
                  color: Theme.of(context).primaryColor
                )
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard({
    required BuildContext context,
    required String key,
    required String content,
    IconData? icon,
    String image = ""
  }) => Container(
    padding: EdgeInsets.all(Sizing.space(12)),
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
          Row(
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
          )
        ],
        if(image.isEmpty) ...[
          SText(
            text: content,
            size: Sizing.font(15),
            color: CommonColors.lightTheme
          )
        ]
      ],
    )
  );
}