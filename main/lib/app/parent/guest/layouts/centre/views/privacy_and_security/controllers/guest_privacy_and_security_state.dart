import 'package:user/library.dart';
import 'package:get/get.dart';

class GuestPrivacyAndSecurityState {
  /// Location permission granted
  RxBool isLocationGranted = RxBool(false);

  /// Storage permission granted
  RxBool isStorageGranted = RxBool(false);

  /// Notification permission granted
  RxBool isNotificationGranted = RxBool(false);

  /// Camera permission granted
  RxBool isCameraGranted = RxBool(false);

  /// Security type for login
  Rx<Preference> preference = Database.guestPreference.obs;
}