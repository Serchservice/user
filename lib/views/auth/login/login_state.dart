import 'package:get/get.dart';

class LoginState {
  /// Email address of the user
  RxString emailAddress = "".obs;

  /// Is Verifying
  RxBool isVerifying = false.obs;

  /// Is password visible
  RxBool isVisible = true.obs;

  /// Name of the email address
  RxString name = "".obs;
}