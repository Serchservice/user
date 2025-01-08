import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:user/library.dart';

class Tip2FixCallBottomBar extends StatelessWidget {
  final CallController controller;
  const Tip2FixCallBottomBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Sizing.space(16), horizontal: Sizing.space(4)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() => CircledButton(
            title: "Mic",
            icon: controller.state.isAudioMuted.value ? Icons.mic_off_rounded : Icons.mic_rounded,
            backgroundColor: darkAlternateColor,
            iconColor: CommonColors.lightTheme,
            onClick: controller.toggleMic,
          )),
          const SizedBox(width: 10),
          Obx(() => CircledButton(
            title: "Camera",
            icon: controller.state.isCameraEnabled.value ? Icons.videocam_rounded : Icons.videocam_off_rounded,
            backgroundColor: darkAlternateColor,
            iconColor: CommonColors.lightTheme,
            onClick: controller.toggleCamera,
          )),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircledButton(
                  title: "End",
                  icon: Icons.call_end_rounded,
                  backgroundColor: CommonColors.error,
                  iconColor: CommonColors.lightTheme,
                  onClick: controller.end,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}