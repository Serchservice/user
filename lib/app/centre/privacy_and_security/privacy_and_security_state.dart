import 'package:get/get.dart';
import 'package:user/library.dart';

class PrivacyAndSecurityState {
  /// Location permission granted
  RxBool isLocationGranted = RxBool(false);

  /// Storage permission granted
  RxBool isStorageGranted = RxBool(false);

  /// Notification permission granted
  RxBool isNotificationGranted = RxBool(false);

  /// Contact permission granted
  RxBool isContactGranted = RxBool(false);

  /// Microphone permission granted
  RxBool isMicrophoneGranted = RxBool(false);

  /// Camera permission granted
  RxBool isCameraGranted = RxBool(false);

  /// For multi factor
  Rx<AuthResponse> auth = Database.auth.obs;

  /// Security type for login
  Rx<Preference> preference = Database.preference.obs;

  /// Password last updated time
  RxString passwordLastUpdatedAt = RxString("**********");
}