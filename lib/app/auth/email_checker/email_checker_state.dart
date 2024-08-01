import 'package:get/get.dart';

class EmailCheckerState {
  /// Whether it is verifying the email or not
  RxBool isVerifying = false.obs;

  /// The referral code from the referral link the user clicked on
  RxString referral = "".obs;

  /// When the email was used to start account creation in Serch provider
  RxBool hasProfile = false.obs;

  /// Toggle password visibility
  RxBool isVisible = false.obs;
}