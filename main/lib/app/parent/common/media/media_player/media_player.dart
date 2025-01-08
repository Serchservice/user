import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaPlayer extends StatelessWidget {
  final String audio;

  const MediaPlayer({super.key, required this.audio});

  @override
  Widget build(BuildContext context) {
    return GetX<MediaPlayerController>(
      init: MediaPlayerController(audio: audio),
      builder: (controller) {
        bool isPlaying = controller.state.isPlaying.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Slider(
              value: controller.state.currentPosition.value,
              max: controller.state.totalDuration.value,
              onChanged: controller.seek,
              activeColor: Theme.of(context).primaryColorLight,
              inactiveColor: CommonColors.shimmerBase.withValues(alpha: .48),
              thumbColor: Theme.of(context).primaryColor,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SText(
                  text: controller.playingTime(),
                  color: Theme.of(context).primaryColor
                ),
                CircledButton(
                  icon: isPlaying ? Icons.pause : Icons.play_arrow,
                  title: isPlaying ? "Pause" : "Play",
                  iconColor: Theme.of(context).primaryColor,
                  onClick: isPlaying ? controller.pauseAudio : controller.playAudio,
                ),
              ],
            ),
          ],
        );
      }
    );
  }
}