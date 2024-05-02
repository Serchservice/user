import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ResetPasswordRequestController extends GetxController {
  ResetPasswordRequestController();
  final state = ResetPasswordRequestState();

  final Connect _connect = Connect(useToken: false);

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
      try {
        var response = await _connect.get(endpoint: "/auth/password/reset/check?emailAddress=${controller.text.trim()}");
        state.isVerifying.value = false;
        var apiResponse = ApiResponse.fromJson(response.data);
        if(apiResponse.isOk || apiResponse.isEmailNotVerified) {
          Navigate.to(ResetPasswordConfirmationLayout.route, parameters: {
            "email_address": controller.text.trim(),
            "name": apiResponse.data
          });
        } else {
          SnackBars.top(message: apiResponse.message, type: Snackbar.error);
          return;
        }
      } on Exception catch (e) {
        state.isVerifying.value = false;
        Connect.showError(e);
      }
    } else {
      return;
    }
  }
}