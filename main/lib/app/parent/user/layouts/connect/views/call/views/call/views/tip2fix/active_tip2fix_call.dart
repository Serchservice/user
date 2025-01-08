import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;

class ActiveTip2FixCall extends StatelessWidget {
  final CallController controller;

  const ActiveTip2FixCall({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          _buildBody(context, controller),
          SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              children: [
                Tip2FixCallTopBar(controller: controller),
                const Expanded(child: SizedBox()),
                Tip2FixCallBottomBar(controller: controller)
              ],
            ),
          ),
          Tip2FixCallBottomFloater(controller: controller),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, CallController controller) {
    double height = 200;
    double width = 140;

    return Builder(
      builder: (context) {
        return stream.FloatingViewContainer(
          floatingViewWidth: width,
          floatingViewHeight: height,
          floatingViewPadding: 25,
          enableSnappingBehavior: true,
          floatingViewAlignment: stream.FloatingViewAlignment.bottomRight,
          floatingView: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColorLight,
                    blurRadius: 4,
                    spreadRadius: 2,
                  ),
                ],
              ),
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: controller.localParticipant != null && controller.localParticipant!.isSpeaking
                    ? Border.all(color: CommonColors.green, width: 2)
                    : null,
              ),
              child: controller.localParticipant != null
                ? stream.StreamVideoRenderer(
                  call: controller.streamCall,
                  participant: controller.localParticipant!,
                  videoTrackType: stream.SfuTrackType.video,
                  videoFit: stream.VideoFit.cover,
                  placeholderBuilder: (context) {
                    return Tip2FixCallUser(avatar: Database.auth.avatar, image: Database.auth.image, radius: 50);
                  },
                )
                : Tip2FixCallUser(avatar: Database.auth.avatar, image: Database.auth.image, radius: 50),
            ),
          ),
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: controller.remoteParticipant != null
              ? stream.StreamVideoRenderer(
                call: controller.streamCall,
                participant: controller.remoteParticipant!,
                videoTrackType: stream.SfuTrackType.video,
                videoFit: stream.VideoFit.cover,
                placeholderBuilder: (context) {
                  return Obx(() => Tip2FixCallUser(
                    avatar: controller.state.call.value.avatar,
                    image: controller.state.call.value.image
                  ));
                },
              )
              : Obx(() => Tip2FixCallUser(
                avatar: controller.state.call.value.avatar,
                image: controller.state.call.value.image
              )),
          ),
        );
      }
    );
  }
}