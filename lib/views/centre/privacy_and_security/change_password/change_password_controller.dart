import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ChangePasswordController extends GetxController {
  ChangePasswordController();
  final state = ChangePasswordState();
  final PrivacyAndSecurityController security = Get.find<PrivacyAndSecurityController>();

  final Connect _connect = Connect();

  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void onClose() {
    currentPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();

    super.onClose();
  }

  void toggleCurrent() => state.isCurrentVisible.toggle();
  void toggleNew() => state.isNewVisible.toggle();
  void toggleConfirm() => state.isConfirmVisible.toggle();

  void changePassword() async {
    if(formkey.currentState != null && formkey.currentState!.validate()) {
      state.isConfirming.value = true;
      try {
        var res = await _connect.post(
          endpoint: "/auth/password/change",
          body: {
            "new_password": newPassword.text.trim(),
            "old_password": currentPassword.text.trim(),
            "device": Database.device.toJson()
          }
        );
        state.isConfirming.value = false;
        ApiResponse response = ApiResponse.fromJson(res.data);
        if(response.isOk) {
          security.fetchPasswordLastUpdatedAt();
          SnackBars.top(message: response.message, type: Snackbar.success);
          AuthResponse auth = AuthResponse.fromJson(response.data);
          Database.saveAuth(auth);
          formkey.currentState?.reset();
          newPassword.clear();
          currentPassword.clear();
          confirmPassword.clear();
          return;
        } else {
          SnackBars.top(message: response.message, type: Snackbar.error);
          return;
        }
      } on Exception catch (e) {
        state.isConfirming.value = false;
        Connect.showError(e);
        return;
      }
    } else {
      return;
    }
  }
}