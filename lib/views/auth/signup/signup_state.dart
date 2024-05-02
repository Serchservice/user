import 'package:get/get.dart';

class SignupState {
  /// Is saving the profile
  RxBool isSaving = false.obs;

  /// Selected Gender
  RxString gender = "".obs;

  /// Country code
  RxString countryCode = "".obs;

  /// Country name
  RxString country = "".obs;

  /// Country ISO Code
  RxString isoCode = "".obs;

  /// Toggle between password visibility
  RxBool isVisible = true.obs;

  /// Referral Code
  RxString referral = "".obs;

  /// Email Address
  RxString emailAddress = "".obs;
}