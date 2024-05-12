import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class LoginController extends GetxController {
  LoginController();
  final state = LoginState();

  final Connect _connect = Connect(useToken: false);

  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final params = Get.parameters;

  @override
  void onInit() {
    state.emailAddress.value = params["email_address"] ?? "";
    state.name.value = params["name"] ?? "";

    if(state.emailAddress.value.isEmpty) {
      SnackBars.top(message: "Unformatted email address", type: Snackbar.error);
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigate.back();
      });
    }
    super.onInit();
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }

  void toggle() => state.isVisible.toggle();

  void login(BuildContext context) async {
    CommonUtility.unfocus(context);

    if(formkey.currentState != null && formkey.currentState!.validate()) {
      state.isVerifying.value = true;
      try {
        var response = await _connect.post(
          endpoint: "/auth/user/login",
          body: {
            "password": passwordController.text.trim(),
            "platform": Database.device.platform,
            "device": Database.device.toJson(),
            "email_address": state.emailAddress.value,
          }
        );
        state.isVerifying.value = false;
        ApiResponse apiResponse = ApiResponse.fromJson(response.data);
        if(apiResponse.isOk) {
          AuthResponse auth = AuthResponse.fromJson(apiResponse.data);
          Database.saveAuth(auth);
          if(auth.hasMfa && !Database.preference.remember && (Database.preference.isMFA || Database.preference.isBoth || Database.preference.isNone)) {
            AuthWithMultiFactor.login();
          } else {
            Navigate.all(HomeLayout.route);
          }
        } else {
          SnackBars.top(message: apiResponse.message, type: Snackbar.error);
          return;
        }
      } on Exception catch (e) {
        state.isVerifying.value = false;
        Connect.showError(e);
        return;
      }
    } else {
      return;
    }
  }
}