import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestCentreLayout extends GetResponsiveView<GuestCentreController> {
  GuestCentreLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => GuestCentreHeader(
          name: GuestParentController.data.state.guest.value.name,
          confirmed: GuestParentController.data.state.guest.value.confirmed,
          avatar: GuestParentController.data.state.guest.value.avatar
        )),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...controller.tabs.map((tab) => CentreNavigator(
                  tab: tab,
                  onTap: () {
                    if(tab.path.isNotEmpty) {
                      Navigate.to(tab.path);
                    }
                  },
                )),
                GuestCentreMoreSection(controller: controller),
                GuestCentreAppDownloadSection(controller: controller),
              ]
            )
          ),
        )
      ],
    );
  }
}