import 'package:get/get.dart';

class ResetPasswordState {
  /// Is Verifying
  RxBool isVerifying = false.obs;

  /// Is password visible
  RxBool isVisible = true.obs;

  /// Email address of the user
  RxString emailAddress = "".obs;

  /// Name of the account holder
  RxString name = "".obs;
}