import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestHomeState {
  /// Current Index of the navigator
  RxInt routeIndex = 0.obs;

  /// Timeout count
  RxInt timeout = 59.obs;

  /// Current theme mode
  Rx<ThemeType> theme = Database.preference.theme.obs;

  /// First name
  RxString firstName = RxString(Database.guest.firstName);

  /// Full name
  RxString name = RxString(Database.guest.name);

  /// Category image
  RxString image = RxString(Database.guest.avatar);

  /// Avatar
  RxString avatar = RxString(Database.guest.avatar);
}