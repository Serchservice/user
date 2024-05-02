import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ResetPasswordConfirmationController extends GetxController {
  ResetPasswordConfirmationController();
  final state = ResetPasswordConfirmationState();

  final params = Get.parameters;

  final Connect _connect = Connect(useToken: false);
  Timer? _timer;

  List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());

  @override
  void onInit() {
    state.emailAddress.value = params["email_address"] ?? "";
    state.name.value = params["name"] ?? "";

    if(state.emailAddress.value.isNotEmpty) {
      startTimer();
    } else {
      SnackBars.top(message: "Unformatted email address", type: Snackbar.error);
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigate.back();
      });
    }
    super.onInit();
  }

  void startTimer() {
    if(state.timeout.value != 59) {
      _timer?.cancel();
      state.timeout.value = 59;

      updateTimer();
    } else {
      updateTimer();
    }
  }

  void updateTimer() {
    Timer.periodic(const Duration(seconds: 1), (newTimer) {
      _timer = newTimer;

      if(state.timeout.value == 0) {
        newTimer.cancel();
        state.isCounting.value = false;
      } else {
        state.timeout.value--;
        state.isCounting.value = true;
      }
    });
  }

  void resend(BuildContext context) async {
    CommonUtility.unfocus(context);

    state.isResending.value = true;
    try {
      var response = await _connect.get(endpoint: "/auth/password/reset/check?emailAddress=${state.emailAddress.value}");
      state.isResending.value = false;
      var apiResponse = ApiResponse.fromJson(response.data);
      SnackBars.top(message: apiResponse.message, type: apiResponse.isOk ? Snackbar.success : Snackbar.error);
      if(apiResponse.isOk) {
        startTimer();
      }
      return;
    } on Exception catch (e) {
      state.isResending.value = false;
      Connect.showError(e);
    }
  }

  void verify(BuildContext context) async {
    CommonUtility.unfocus(context);

    state.otp.value = controllers.map((controller) => controller.text).join('');
    if(state.otp.isEmpty || state.otp.value.length < 6) {
      SnackBars.top(message: "Incorrect token", type: Snackbar.error);
      return;
    }
    state.isVerifying.value = true;
    try {
      var response = await _connect.post(
        endpoint: "/auth/reset/verify",
        body: {
          "emailAddress": state.emailAddress.value,
          "token": state.otp.value,
        }
      );
      state.isVerifying.value = false;
      var apiResponse = ApiResponse.fromJson(response.data);
      if(apiResponse.isOk) {
        Navigate.off(ResetPasswordLayout.route, parameters: {
          "email_address": state.emailAddress.value,
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
  }

  @override
  void onClose() {
    for (var element in controllers) {
      element.dispose();
    }
    super.onClose();
  }
}