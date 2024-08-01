import 'package:get/get_rx/get_rx.dart';
import 'package:user/library.dart';

class ScheduleTimePickerState {
  /// Fetching the time list
  RxBool isFetchingTimes = RxBool(true);

  /// List of times to pick from
  RxList<Time> times = <Time>[].obs;

  /// Selected time
  Rx<Time> selected = Time(amTaken: false, pmTaken: false, time: "").obs;

  /// Selected time part (AM/PM)
  RxString part = RxString("");

  /// Scheduling
  RxBool isScheduling = RxBool(false);

  /// Picked address
  Rx<Address> location = Database.address.obs;

  /// Formatted amount
  RxString amount = RxString("");
}