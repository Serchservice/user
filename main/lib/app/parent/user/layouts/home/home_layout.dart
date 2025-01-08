import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeLayout extends GetResponsiveView<HomeController> {
  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width,
          padding: EdgeInsets.all(Sizing.space(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigate.to(AppInformationLayout.route),
                child: Image.asset(
                  Media.serch,
                  width: 80,
                  color: Theme.of(context).primaryColor
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: controller.openAccounts,
                tooltip: "View accounts",
                icon: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle_rounded,
                      color: Theme.of(context).primaryColor
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Theme.of(context).primaryColor
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FakeField(
                    onTap: () => RequestEntryLayout.request(),
                    searchText: "What service provider are you looking for?",
                    buttonText: "Search",
                    needPadding: false,
                  ),
                  const SizedBox(height: 30),
                  SText(
                    text: "Do more with Serch",
                    size: Sizing.space(16),
                    weight: FontWeight.w700,
                    flow: TextOverflow.ellipsis,
                    color: Theme.of(context).primaryColor
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: controller.contentHeight),
                    child: ListView.separated(
                      itemCount: controller.moreTips.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 12);
                      },
                      itemBuilder: (context, index) {
                        return AccountTipItem(
                          itemHeight: controller.contentHeight,
                          itemWidth: 330,
                          view: controller.moreTips[index],
                          onTap: controller.onMoreTap,
                          imageHeight: controller.contentHeight,
                          imageWidth: controller.contentWidth
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  SText(
                    text: "${DateFormat.EEEE().format(DateTime.now())}'s Activity",
                    size: Sizing.space(16),
                    weight: FontWeight.w700,
                    flow: TextOverflow.ellipsis,
                    color: Theme.of(context).primaryColor
                  ),
                  const SizedBox(height: 10),
                  Obx(() => DashboardView(
                    dashboard: controller.state.dashboard.value,
                    isLoading: controller.state.isLoading.value,
                  )),
                  const SizedBox(height: 30),
                  SText(
                    text: "Go further with Serch",
                    size: Sizing.space(16),
                    weight: FontWeight.w700,
                    flow: TextOverflow.ellipsis,
                    color: Theme.of(context).primaryColor
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: controller.contentHeight),
                    child: ListView.separated(
                      itemCount: controller.goFurtherTips.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 12);
                      },
                      itemBuilder: (context, index) {
                        return MoreActionTipItem(
                          itemHeight: controller.contentHeight,
                          itemWidth: 330,
                          view: controller.goFurtherTips[index],
                          onTap: controller.onGoFurtherTap,
                          imageHeight: controller.contentHeight,
                          imageWidth: controller.contentWidth
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  SText(
                    text: "Popular Categories",
                    size: Sizing.space(16),
                    weight: FontWeight.w700,
                    flow: TextOverflow.ellipsis,
                    color: Theme.of(context).primaryColor
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    if(controller.state.isFetchingPopularCategories.value) {
                      return LoadingShimmer(
                        content: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: controller.count(),
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
                        gridDelegate: controller.count(),
                        shrinkWrap: true,
                        itemCount: controller.state.popularCategories.length,
                        itemBuilder: (context, index) {
                          return HomeCategoryItem(
                            category: controller.state.popularCategories[index],
                            onPicked: HomeCategorySelector.open
                          );
                        },
                      );
                    }
                  }),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ]
    );
  }
}