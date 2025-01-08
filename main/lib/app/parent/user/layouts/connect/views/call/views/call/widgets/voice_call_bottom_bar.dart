import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:user/library.dart';

class VoiceCallBottomBar extends StatelessWidget {
  final CallController controller;
  const VoiceCallBottomBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isOnCall = controller.state.call.value.isOnCall;

      return Padding(
        padding: EdgeInsets.symmetric(vertical: Sizing.space(16), horizontal: Sizing.space(4)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircledButton(
              title: "Mic",
              icon: controller.state.isAudioMuted.value ? Icons.mic_off_rounded : Icons.mic_rounded,
              backgroundColor: darkAlternateColor,
              iconColor: CommonColors.lightTheme,
              onClick: controller.toggleMic,
            ),
            const SizedBox(width: 10),
            CircledButton(
              title: "Speaker",
              icon: controller.state.isOnSpeaker.value ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              backgroundColor: darkAlternateColor,
              iconColor: CommonColors.lightTheme,
              onClick: controller.toggleSpeaker,
            ),
            if(isOnCall) ...[
              const SizedBox(width: 10),
              CircledButton(
                title: "End",
                icon: Icons.call_end_rounded,
                backgroundColor: CommonColors.error,
                iconColor: CommonColors.lightTheme,
                onClick: controller.end,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 50,
                      child: LoadingButton(
                        text: "Invite",
                        buttonColor: darkAlternateColor,
                        textColor: CommonColors.lightTheme,
                        isCircular: false,
                        borderRadius: 24,
                        onClick: () => CallDetailSheet.open(controller: controller, showInvite: true),
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizing.space(12),
                          vertical: Sizing.space(4)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
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
            ]
          ],
        ),
      );
    });
  }
}