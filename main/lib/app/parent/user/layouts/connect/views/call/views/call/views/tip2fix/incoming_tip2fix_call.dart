import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;
import 'package:user/library.dart';

class IncomingTip2FixCall extends StatelessWidget {
  final CallController controller;

  const IncomingTip2FixCall({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      ActiveCallResponse active = controller.state.call.value;

      return Center(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: controller.localParticipant != null
                ? stream.StreamVideoRenderer(
                  call: controller.streamCall,
                  participant: controller.localParticipant!,
                  videoTrackType: stream.SfuTrackType.video,
                  videoFit: stream.VideoFit.cover,
                  placeholderBuilder: (context) {
                    return Tip2FixCallUser(avatar: active.avatar, image: active.image);
                  },
                )
                : Tip2FixCallUser(avatar: active.avatar, image: active.image),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                children: [
                  Tip2FixCallTopBar(controller: controller),
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Sizing.space(16),
                        horizontal: Sizing.space(4)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircledButton(
                          title: "End call",
                          icon: Icons.call_end_rounded,
                          backgroundColor: CommonColors.error,
                          iconColor: CommonColors.lightTheme,
                          onClick: controller.end,
                        ),
                        CircledButton(
                          title: "Answer call",
                          icon: Icons.call_rounded,
                          backgroundColor: CommonColors.success,
                          iconColor: CommonColors.lightTheme,
                          onClick: controller.answer,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Tip2FixCallBottomFloater(controller: controller, text: "Incoming"),
          ],
        ),
      );
    });
  }
}