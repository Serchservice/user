import 'package:get/get.dart';

class ResetPasswordConfirmationState {
  /// Timeout count
  RxInt timeout = 59.obs;

  /// To toggle the counting state
  RxBool isCounting = true.obs;

  /// The email address to verify
  RxString emailAddress = "".obs;

  /// The OTP
  RxString otp = "".obs;

  /// Check if the OTP is being resent
  RxBool isResending = false.obs;

  /// If the email otp is being verified
  RxBool isVerifying = false.obs;

  /// Name of the account holder
  RxString name = "".obs;
}