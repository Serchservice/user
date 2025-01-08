import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;
import 'package:user/library.dart';

class OutgoingTip2FixCall extends StatelessWidget {
  final CallController controller;
  const OutgoingTip2FixCall({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
                    return Tip2FixCallUser(avatar: Database.auth.avatar, image: Database.auth.image);
                  },
                )
                : Tip2FixCallUser(avatar: Database.auth.avatar, image: Database.auth.image),
          ),
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
}