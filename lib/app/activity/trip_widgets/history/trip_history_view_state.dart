import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:user/library.dart';

class TripHistoryViewState {
  /// Current position
  RxDouble currentPosition = RxDouble(0.0);

  /// Total duration
  RxDouble totalDuration = RxDouble(0.0);

  /// Is playing
  RxBool isPlaying = RxBool(false);

  /// Trip
  Rx<TripResponse> trip = TripResponse.empty().obs;
}