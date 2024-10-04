import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

/// Argument: [SerchCategory] in json (Optional)
class SkillSearchLayout extends GetResponsiveView<SkillSearchController> {
  static String get route => "/dashboard/request/search";
  SkillSearchLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: Obx(() {
          if(controller.state.category.value.category.isNotEmpty) {
            return SText.center(
              text: "Search with Serch (${controller.state.category.value.type})",
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
            if(controller.state.category.value.category.isNotEmpty) {
              return CategoryImage(image: controller.state.category.value.image, height: 50, width: 50);
            } else {
              return Container();
            }
          })
        ],
      ),
      child: Column(
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
          Obx(() {
            if(controller.state.isSearching.value) {
              return Expanded(
                child: LoadingShimmer(
                  content: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 80,
                        margin: EdgeInsets.symmetric(vertical: Sizing.space(2)),
                        color: Theme.of(context).primaryColorLight,
                      );
                    },
                  ),
                ),
              );
            } else if(controller.state.specializations.isNotEmpty) {
              return Expanded(
                child: ListView.separated(
                  itemCount: controller.state.specializations.length,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return Divider(color: Theme.of(context).primaryColorLight);
                  },
                  itemBuilder: (context, index) {
                    return SpecializationView(
                      specialization: controller.state.specializations[index],
                      onTap: () {
                        controller.pickSpecialization(controller.state.specializations[index]);
                        CommonUtility.unfocus(context);
                      },
                      needPadding: true,
                    );
                  },
                ),
              );
            } else {
              return Container();
            }
          }),
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
                  child: SpecializationView(
                    specialization: controller.state.specialization.value,
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