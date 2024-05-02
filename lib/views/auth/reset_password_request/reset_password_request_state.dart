import 'package:get/get.dart';

class ResetPasswordRequestState {
  /// Whether it is verifiying the email or not
  RxBool isVerifying = false.obs;

  RxString referredBy = "".obs;
}