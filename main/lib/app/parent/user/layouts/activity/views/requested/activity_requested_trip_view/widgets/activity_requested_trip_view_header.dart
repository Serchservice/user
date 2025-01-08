import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityRequestedTripViewHeader extends StatelessWidget {
  final ActivityRequestedTripViewController controller;

  const ActivityRequestedTripViewHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Sizing.space(12)),
      color: Theme.of(context).appBarTheme.backgroundColor,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GoBack(size: 30, radius: 10, icon: Icons.arrow_back),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Obx(() {
                  return SText(
                    text: "You are requesting for ${CommonUtility.textWithAorAn(controller.state.trip.value.category)}",
                    size: Sizing.font(18),
                    weight: FontWeight.bold,
                    color: Theme.of(context).primaryColor
                  );
                }),
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