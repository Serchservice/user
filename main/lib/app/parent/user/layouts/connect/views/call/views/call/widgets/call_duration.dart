import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class CallDuration extends StatelessWidget {
  final CallController controller;
  final String? text;

  const CallDuration({super.key, required this.controller, this.text});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(controller.state.call.value.isOnCall) {
        return Column(
          crossAxisAlignment: controller.state.call.value.isVoice
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SText(
              text: text ?? controller.state.call.value.status.type,
              size: Sizing.font(14),
              color: CommonColors.hint,
            ),
            SText(
              text: controller.state.duration.value,
              color: CommonColors.hint,
              size: Sizing.font(12),
            ),
          ],
        );
      } else {
        return SText(
          text: text ?? controller.state.call.value.status.type,
          size: Sizing.font(16),
          color: CommonColors.hint,
        );
      }
    });
  }
}