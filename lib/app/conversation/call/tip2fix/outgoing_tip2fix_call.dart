import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;

class OutgoingTip2FixCall extends StatelessWidget {
  final stream.Call call;
  final ActiveCallResponse active;
  final CallController controller;
  final stream.CallState callState;

  const OutgoingTip2FixCall({
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
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircledButton(
              title: "My wallet",
              asset: Media.wallet,
              backgroundColor: darkAlternateColor,
              onClick: () => ViewWalletSheet.open(controller: controller),
            ),
          )
        ],
      ),
      child: Center(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
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
                  SText(
                    text: active.status.type,
                    size: Sizing.font(16),
                    color: CommonColors.hint,
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
                          title: "Switch Camera",
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
            Positioned(
              bottom: 90,
              right: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  height: 250,
                  width: 160,
                  color: Theme.of(context).textSelectionTheme.selectionColor,
                  child: stream.StreamCallParticipant(
                    call: call,
                    participant: callState.localParticipant!,
                  ),
                ),
              ),
            ),
            Positioned(
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
                  SText(
                    text: active.name,
                    size: Sizing.font(14),
                    weight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}