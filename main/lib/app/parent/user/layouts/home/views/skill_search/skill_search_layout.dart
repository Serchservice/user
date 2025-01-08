import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:user/library.dart';

class SkillSearchLayout extends GetResponsiveView<SkillSearchController> {
  static const String route = "/home/search";

  static void to({SerchCategory? category}) {
    Map<String, String>? param = category != null ? {"category": category.type} : null;

    Navigate.to(route, parameters: param, arguments: category);
  }

  SkillSearchLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: Obx(() {
          if(controller.hasCategory) {
            return SText.center(
              text: "Search with Serch | (${controller.state.category.value.type})",
              size: Sizing.font(18),
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor
            );
          } else {
            return SText.center(
              text: "Search with Serch",
              size: Sizing.font(18),
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor
            );
          }
        }),
        actions: [
          Obx(() {
            if(controller.hasCategory) {
              return CategoryImage(image: controller.state.category.value.image, height: 50, width: 50);
            } else {
              return Container();
            }
          })
        ],
      ),
      child: Column(
        // spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            padding: EdgeInsets.only(
              bottom: Sizing.space(16),
              left: Sizing.space(16),
              right: Sizing.space(16)
            ),
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SteppingList(steppings: steps(context)),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(child: SizedBox(width: 20)),
                    Obx(() => Material(
                      color: controller.showButton ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.surface,
                      child: InkWell(
                        onTap: controller.showButton ? () => controller.search() : null,
                        child: Padding(
                          padding: EdgeInsets.all(Sizing.space(9)),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: Sizing.space(24),
                            color: Theme.of(context).scaffoldBackgroundColor
                          )
                        )
                      )
                    ))
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: PullToRefresh(
              onRefreshed: controller.skillController.refresh,
              child: PagedListView<int, Specialization>.separated(
                pagingController: controller.skillController,
                separatorBuilder: (context, index) {
                  return Divider(color: Theme.of(context).primaryColorLight);
                },
                builderDelegate: PagedChildBuilderDelegate<Specialization>(
                  itemBuilder: (context, skill, index) {
                    return SkillSearchItem(
                      skill: skill,
                      onTap: () {
                        controller.pickSpecialization(skill);
                        CommonUtility.unfocus(context);
                      },
                      needPadding: true,
                    );
                  },
                  firstPageErrorIndicatorBuilder: (context) => PagingFirstPageErrorIndicator(
                    error: controller.skillController.error,
                    onTryAgain: () => controller.skillController.refresh()
                  ),
                  firstPageProgressIndicatorBuilder: (_) => PagingFirstPageLoadingIndicator(height: 80,),
                  noItemsFoundIndicatorBuilder: (context) => PagingNoItemFoundIndicator(
                    message: "No skills found",
                    icon: Icons.wind_power_rounded,
                  ),
                  // noMoreItemsIndicatorBuilder: (_) => NoMoreItemsIndicator(),
                  // newPageProgressIndicatorBuilder: (_) => NewPageProgressIndicator(),
                  // newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
                  //   error: controller.skillController.error,
                  //   onTryAgain: () => controller.skillController.retryLastFailedRequest(),
                  // ),
                ),
              ),
            ),
          ),
        ]
      )
    );
  }

  List<Stepping> steps(BuildContext context) {
    return [
      Stepping(
        icon: Icons.search_outlined,
        content: Column(
          children: [
            Field(
              padding: const EdgeInsets.all(8),
              hintText: "What's on your mind?",
              controller: controller.searchController,
            ),
            Obx(() {
              if(controller.state.specialization.value.special.isEmpty) {
                return Container(height: 30);
              } else {
                return Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: SkillSearchItem(
                    skill: controller.state.specialization.value,
                    onTap: () => controller.removeSpecialization(),
                    showRemove: true,
                  )
                );
              }
            }),
          ],
        ),
      ),
      Stepping(
        icon: Icons.location_searching_rounded,
        content: Column(
          children: [
            SizedBox(
              height: 50,
              child: LocationSearchLayout.search(
                onSelect: (address) => controller.state.location.value = address,
                text: "Search city, street, state, etc",
                color: Theme.of(context).scaffoldBackgroundColor
              ),
            ),
            Obx(() {
              if(controller.state.location.value.latitude == 0.0) {
                return Container();
              } else {
                return Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: LocationView(address: controller.state.location.value)
                );
              }
            }),
          ],
        ),
      )
    ];
  }
}