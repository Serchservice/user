import 'package:get/get_rx/src/rx_types/rx_types.dart';

class MediaPlayerState {
  /// Current position
  RxDouble currentPosition = RxDouble(0.0);

  /// Total duration
  RxDouble totalDuration = RxDouble(0.0);

  /// Is playing
  RxBool isPlaying = RxBool(false);

  RxString audio = RxString("");
}