import 'package:get/state_manager.dart';
import 'package:map_launcher/map_launcher.dart';

class NavigationOptionSheetState {
  /// Whether a route is being created for navigation
  RxBool isLoading = RxBool(false);

  /// List of maps available on device
  RxList<AvailableMap> maps = RxList([]);
}