import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityActiveTripViewHeader extends StatelessWidget {
  final ActivityActiveTripViewController controller;

  const ActivityActiveTripViewHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Sizing.space(12)),
      color: Theme.of(context).appBarTheme.backgroundColor,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const GoBack(size: 30, radius: 10, icon: Icons.arrow_back),
              const Expanded(child: SizedBox(width: 15)),
              Obx(() => LoadingButton(
                text: controller.state.isMinimized.value ? "View details" : "Minimize details",
                buttonColor: Theme.of(context).colorScheme.surface,
                textColor: Theme.of(context).primaryColor,
                textSize: 12,
                borderRadius: 30,
                padding: EdgeInsets.all(Sizing.space(6)),
                onClick: controller.state.isMinimized.toggle,
              ))
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Obx(() => SText(
                  text: "You are on a trip with ${CommonUtility.textWithAorAn(controller.state.trip.value.category)}",
                  size: Sizing.font(18),
                  weight: FontWeight.bold,
                  color: Theme.of(context).primaryColor
                )),
              ),
              const SizedBox(width: 20),
              Container(
                padding: EdgeInsets.all(Sizing.space(4)),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Obx(() => CategoryImage(image: controller.state.trip.value.image, width: 60, height: 60))
              ),
            ],
          ),
        ],
      )
    );
  }
}