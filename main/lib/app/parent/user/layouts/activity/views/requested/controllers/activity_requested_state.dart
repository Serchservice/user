import 'package:user/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ActivityRequestedState {
  /// Current active filter index
  RxInt filterIndex = RxInt(0);

  /// Current trip filter
  RxInt tripFilterIndex = RxInt(0);

  /// Current trip filter category
  RxString tripFilterCategory = RxString("");

  /// Current schedule filter
  RxInt scheduleFilterIndex = RxInt(0);

  /// Current schedule filter category
  RxString scheduleFilterCategory = RxString("");

  /// List of trips requested
  RxList<TripResponse> trips = <TripResponse>[].obs;

  /// List of requested schedules
  RxList<Schedule> schedules = <Schedule>[].obs;
}