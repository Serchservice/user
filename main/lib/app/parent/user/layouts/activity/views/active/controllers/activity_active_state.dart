import 'package:user/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ActivityActiveState {
  /// Current active filter index
  RxInt filterIndex = RxInt(0);

  /// Current trip filter
  RxInt tripFilterIndex = RxInt(0);

  /// Current trip filter category
  RxString tripFilter = RxString("");

  /// Current schedule filter
  RxInt scheduleFilterIndex = RxInt(0);

  /// Current schedule filter category
  RxString scheduleFilter = RxString("");

  RxList<TripResponse> trips = RxList([]);

  RxList<Schedule> schedules = RxList([]);
}