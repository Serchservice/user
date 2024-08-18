import 'package:get/state_manager.dart';

class NavigationOptionSheetState {
  /// Whether a route is being created for navigation
  RxBool isCreatingRoute = RxBool(false);

  /// Selected option
  RxInt selected = RxInt(-1);
}