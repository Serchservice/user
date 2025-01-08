import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:user/library.dart';

class RequestEntryRecording extends StatelessWidget {
  final RequestEntryController controller;

  const RequestEntryRecording({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(controller.state.isStoppedRecording.value && controller.state.media.value.path.isNotEmpty) {
        return MediaPlayer(audio: controller.state.media.value.path);
      } else {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SText(
              text: controller.recordingTime(),
              color: Theme.of(context).primaryColor
            ),
            const Expanded(child: SizedBox(width: 20)),
            CircledButton(
              title: controller.recordingOptions().header,
              icon: controller.recordingOptions().icon,
              iconColor: controller.recordingOptions().color,
              onClick: controller.recordingOptions().onClick,
            ),
            if(controller.state.isRecording.value || controller.state.isPausedRecording.value) ...[
              const SizedBox(width: 10),
              CircledButton(
                title: "Stop",
                icon: CupertinoIcons.stop,
                iconColor: CommonColors.error,
                onClick: () => controller.stopRecording()
              ),
              const SizedBox(width: 10),
              CircledButton(
                title: "Delete",
                icon: CupertinoIcons.trash,
                iconColor: CommonColors.error,
                onClick: () => controller.deleteRecording()
              ),
            ]
          ],
        );
      }
    });
  }
}