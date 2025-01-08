import 'package:user/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ActivityHistoryState {
  /// Current active filter index
  RxInt filterIndex = RxInt(0);

  /// Current trip filter sharing
  RxInt tripFilterSharingIndex = RxInt(0);

  /// Current trip filter category index
  RxInt tripFilterCategoryIndex = RxInt(0);

  /// Current trip filter category
  RxString tripFilterCategory = RxString("");

  /// Current trip filter date
  Rx<DateTime> tripFilterDate = DateTime(2009).obs;

  /// Current schedule filter status
  RxInt scheduleFilterStatusIndex = RxInt(0);

  /// Current schedule filter status
  RxString scheduleFilterStatus = RxString("");

  /// Current schedule filter
  RxInt scheduleFilterCategoryIndex = RxInt(0);

  /// Current schedule filter category
  RxString scheduleFilterCategory = RxString("");

  /// Current schedule filter date
  Rx<DateTime> scheduleFilterDate = DateTime(2009).obs;

  RxList<TripResponse> trips = RxList([]);

  RxList<ScheduleGroup> schedules = RxList([]);
}