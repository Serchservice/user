import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestParentState {
  /// Current Index of the navigator
  RxInt routeIndex = 0.obs;

  /// Timeout count
  RxInt timeout = 59.obs;

  /// Current theme mode
  Rx<ThemeType> theme = Database.preference.theme.obs;

  /// Guest profile
  Rx<Guest> guest = Database.guest.obs;
}