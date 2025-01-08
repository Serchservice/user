import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class EmailVerificationController extends GetxController {
  EmailVerificationController();
  final state = EmailVerificationState();

  final ConnectService _connect = Connect(useToken: false);

  final params = Get.parameters;
  Timer? _timer;
  final TextEditingController authController = TextEditingController();
  final FocusNode authFocusNode = FocusNode();

  @override
  void onInit() {
    state.emailAddress.value = params["email_address"] ?? "";
    state.referral.value = params["referral"] ?? "";

    if(state.emailAddress.value.isNotEmpty) {
      startTimer();
    } else {
      redirect();
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

  void resend() async {
    state.isResending.value = true;
    var response = await _connect.get(endpoint: "/auth/email/check?email=${state.emailAddress.value}");
    state.isResending.value = false;
    if(response.isUserNotFound || response.isEmailNotVerified) {
      if(response.isEmailNotVerified) {
        notify.error(message: response.message);
        return;
      } else {
        startTimer();
        return;
      }
    } else {
      notify.error(message: response.message);
      return;
    }
  }

  void verify(String code) async {
    state.otp.value = code;

    if(state.otp.isEmpty || state.otp.value.length < 6) {
      notify.error(message: "Incorrect token");
      return;
    }

    state.isVerifying.value = true;
    var response = await _connect.post(
      endpoint: "/auth/email/verify",
      body: {
        "email_address": state.emailAddress.value,
        "token": state.otp.value,
      }
    );

    state.isVerifying.value = false;
    if(response.isOk) {
      SignupLayout.open(emailAddress: state.emailAddress.value, referral: state.referral.value, isAll: true);
    } else {
      notify.error(message: response.message);
      return;
    }
  }

  @override
  void onClose() {
    authController.dispose();
    authFocusNode.dispose();
    _timer?.cancel();
    super.onClose();
  }
}