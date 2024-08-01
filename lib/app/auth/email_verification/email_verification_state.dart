import 'package:get/get.dart';

class EmailVerificationState {
  /// Timeout count
  RxInt timeout = 59.obs;

  /// To toggle the counting state
  RxBool isCounting = true.obs;

  /// The email address to verify
  RxString emailAddress = "".obs;

  /// The OTP
  RxString otp = "".obs;

  /// Referral Code, if any
  RxString referral = "".obs;

  /// Check if the OTP is being resent
  RxBool isResending = false.obs;

  /// Check if the OTP is being resent
  RxBool isVerifying = false.obs;
}