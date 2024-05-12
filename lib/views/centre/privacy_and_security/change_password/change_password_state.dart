import 'package:get/get.dart';

class ChangePasswordState {
  /// Shows the loading widget if the user clicks on change password button
  RxBool isConfirming = false.obs;

  /// Current password visibility
  RxBool isCurrentVisible = true.obs;

  /// New Password visibility
  RxBool isNewVisible = true.obs;

  /// Confirm new password visibility
  RxBool isConfirmVisible = true.obs;
}