import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:user/library.dart';

class ActivityHistoryTripViewState {
  /// Trip
  Rx<TripResponse> trip = TripResponse.empty().obs;
}