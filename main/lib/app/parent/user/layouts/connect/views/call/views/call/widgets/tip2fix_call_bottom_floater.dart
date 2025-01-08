import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:user/library.dart';

class Tip2FixCallBottomFloater extends StatelessWidget {
  final CallController controller;
  final String? text;

  const Tip2FixCallBottomFloater({super.key, required this.controller, this.text});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 90,
      left: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            controller.asset,
            width: 20,
            color: Theme.of(context).primaryColor,
            height: 20
          ),
          const SizedBox(height: 5),
          Obx(() {
            if(controller.state.call.value.isOnCall) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SText(
                    text: controller.state.call.value.name,
                    size: Sizing.font(14),
                    weight: FontWeight.bold,
                    color: controller.state.isCameraEnabled.value ? CommonColors.hint : Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Sizing.space(4), vertical: Sizing.space(1)),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(4)
                    ),
                    child: SText(
                      text: "${controller.state.call.value.session}",
                      size: Sizing.font(14),
                      weight: FontWeight.bold,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  )
                ],
              );
            } else {
              return SText(
                text: controller.state.call.value.name,
                size: Sizing.font(14),
                weight: FontWeight.bold,
                color: controller.state.isCameraEnabled.value ? CommonColors.hint : Theme.of(context).primaryColor,
              );
            }
          }),
          CallDuration(controller: controller, text: text),
        ],
      ),
    );
  }
}