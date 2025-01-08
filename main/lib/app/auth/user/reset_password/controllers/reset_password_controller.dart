import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ResetPasswordController extends GetxController {
  ResetPasswordController();
  final state = ResetPasswordState();

  final params = Get.parameters;
  final ConnectService _connect = Connect(useToken: false);

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void onInit() {
    state.emailAddress.value = params["email_address"] ?? "";
    state.name.value = params["name"] ?? "";

    if(state.emailAddress.value.isEmpty) {
      redirect();
    }
    super.onInit();
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void toggle() => state.isVisible.toggle();

  void resetPassword(BuildContext context) async {
    CommonUtility.unfocus(context);

    if(formkey.currentState != null && formkey.currentState!.validate()) {
      state.isVerifying.value = true;
      var response = await _connect.post(
          endpoint: "/auth/password/reset",
          body: {
            "emailAddress": state.emailAddress.value,
            "password": passwordController.text.trim()
          }
      );
      state.isVerifying.value = false;
      if(response.isOk) {
        notify.success(message: response.message);
        Navigate.till((route) => Get.currentRoute == EmailCheckerLayout.route);
      } else {
        notify.error(message: response.message);
        return;
      }
    } else {
      return;
    }
  }
}