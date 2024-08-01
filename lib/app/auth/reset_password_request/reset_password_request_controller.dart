import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ResetPasswordRequestController extends GetxController {
  ResetPasswordRequestController();
  final state = ResetPasswordRequestState();

  final ConnectService _connect = Connect(useToken: false);

  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  void verifyEmail(BuildContext context) async {
    CommonUtility.unfocus(context);

    if(formKey.currentState != null && formKey.currentState!.validate()) {
      state.isVerifying.value = true;
      var response = await _connect.get(endpoint: "/auth/password/reset/check?emailAddress=${controller.text.trim()}");
      state.isVerifying.value = false;
      if(response.isOk || response.isEmailNotVerified) {
        Navigate.to(ResetPasswordConfirmationLayout.route, parameters: {
          "email_address": controller.text.trim(),
          "name": response.data
        });
      } else {
        notify.error(message: response.message);
        return;
      }
    } else {
      return;
    }
  }
}