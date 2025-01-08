import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:user/library.dart';

class RequestEntryHeader extends StatelessWidget {
  final RequestEntryController controller;

  const RequestEntryHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(controller.hasProvider) {
        return SizedBox.shrink();
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: _build(context, controller),
        );
      }
    });
  }

  Widget _build(BuildContext context, RequestEntryController controller) {
    return Obx(() {
      if(controller.state.initial.value.category.isNotEmpty) {
        return HomeCategoryItem(category: controller.state.initial.value, smallVersion: true);
      } else if(HomeController.data.state.isFetchingCategories.value) {
        return LoadingShimmer(
          content: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  height: 20,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: CommonColors.shimmerHigh
                  ),
                ),
              ),
              SizedBox(
                height: 120,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: CommonUtility.generateList(4).map((index) {
                      bool isNotLast = index != CommonUtility.generateList(4).length - 1;

                      return Container(
                        height: 120,
                        width: 120,
                        margin: EdgeInsets.only(right: isNotLast ? 8 : 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: CommonColors.shimmerHigh
                        ),
                      );
                    }).toList()
                  )
                ),
              ),
            ],
          ),
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SText(
              text: "Pick a service of your choice",
              size: Sizing.font(16),
              color: Theme.of(context).primaryColor
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: controller.state.categories.map((category) {
                  bool isNotLast = controller.state.categories.indexOf(category) != controller.state.categories.length - 1;

                  return Container(
                    padding: EdgeInsets.only(right: isNotLast ? 8 : 0),
                    child: Obx(() {
                      return HomeCategoryItem(
                        category: category,
                        shouldExpand: false,
                        onPicked: controller.selectCategory,
                        selected: category == controller.state.selected.value,
                      );
                    }),
                  );
                }).toList()
              )
            ),
          ],
        );
      }
    });
  }
}
