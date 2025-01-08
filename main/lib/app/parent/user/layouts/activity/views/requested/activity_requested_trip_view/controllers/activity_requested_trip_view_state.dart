import 'package:user/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ActivityRequestedTripViewState {
  /// Is accepting trip
  RxBool isAccepting = RxBool(false);

  /// Trip
  Rx<TripResponse> trip = TripResponse.empty().obs;
}