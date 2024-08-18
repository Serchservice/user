import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;
import 'package:user/library.dart';

class OutgoingVoiceCall extends StatelessWidget {
  final stream.Call call;
  final ActiveCallResponse active;
  final CallController controller;
  final stream.CallState callState;

  const OutgoingVoiceCall({
    super.key,
    required this.call,
    required this.controller,
    required this.callState,
    required this.active
  });

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      shouldOverride: true,
      backgroundColor: Theme.of(context).textSelectionTheme.selectionColor,
      appbar: AppBar(
        backgroundColor: Theme.of(context).textSelectionTheme.selectionColor,
        leading: GoBack(onTap: () => controller.goBack(false, null), icon: Icons.arrow_back),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircledButton(
              title: "Call Info",
              icon: Icons.info_outline_rounded,
              iconColor: CommonColors.lightTheme,
              backgroundColor: darkAlternateColor,
              onClick: () => CallInfoView.open(controller: controller),
            ),
          )
        ],
      ),
      child: Center(
        child: Column(
          children: [
            const Expanded(child: SizedBox()),
            Stack(
              children: [
                Avatar(radius: 70, avatar: active.avatar),
                Positioned(
                    right: 5,
                    bottom: 0,
                    child: Avatar(radius: 13, avatar: active.image)
                ),
              ],
            ),
            const SizedBox(height: 20),
            SText(
              text: active.name,
              size: Sizing.font(20),
              color: Theme.of(context).primaryColor,
            ),
            SText(
              text: active.status.type,
              size: Sizing.font(16),
              color: CommonColors.hint,
            ),
            const Expanded(child: SizedBox()),
            Image.asset(
                controller.asset,
                width: 100,
                color: Theme.of(context).primaryColor,
                height: 100
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Sizing.space(16),
                  horizontal: Sizing.space(4)
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() => CircledButton(
                    title: "Mic",
                    icon: controller.state.isAudioMuted.value ? Icons.mic_off_rounded : Icons.mic_rounded,
                    backgroundColor: darkAlternateColor,
                    iconColor: CommonColors.lightTheme,
                    onClick: controller.toggleRingingMic,
                  )),
                  const SizedBox(width: 10),
                  Obx(() => CircledButton(
                    title: "Speaker",
                    icon: controller.state.isOnSpeaker.value ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                    backgroundColor: darkAlternateColor,
                    iconColor: CommonColors.lightTheme,
                    onClick: controller.toggleRingingSpeaker,
                  )),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        stream.LeaveCallOption(
                          call: call,
                          icon: Icons.call_end_rounded,
                          onLeaveCallTap: () => controller.end(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}