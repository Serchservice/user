import 'package:user/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class EventState {
  /// Checks if the details panel is minimized
  RxBool isMinimized = RxBool(false);

  /// List of active events
  RxList<ActiveEvent> events = RxList([]);
}