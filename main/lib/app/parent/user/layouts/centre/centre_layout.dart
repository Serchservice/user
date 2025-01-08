import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CentreLayout extends GetResponsiveView<CentreController> {
  CentreLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => CentreHeader(
          name: ParentController.data.state.name.value,
          rating: ParentController.data.state.rating.value,
          avatar: ParentController.data.state.avatar.value
        )),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: controller.quickActions.length,
                      crossAxisSpacing: 20,
                      mainAxisExtent: 100
                    ),
                    itemCount: controller.quickActions.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return CentreQuickAction(action: controller.quickActions[index]);
                    }
                  ),
                ),
                Obx(() {
                  bool showNotification = SpeakWithSerchController.data.state.hasSerchMessage.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: controller.tabs.map((tab) => CentreNavigator(
                      tab: tab,
                      needNotification: tab.index == 1 && showNotification,
                      onTap: () {
                        if(tab.path.isNotEmpty) {
                          Navigate.to(tab.path);
                        }
                      },
                    )).toList(),
                  );
                }),
                const SizedBox(height: 10),
                CentreMoreSection(controller: controller),
                CentreAppDownloadSection(controller: controller),
              ],
            )
          ),
        )
      ],
    );
  }
}