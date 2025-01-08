import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestEmailConfirmationController extends GetxController {
  GuestEmailConfirmationController();
  final state = GuestEmailConfirmationState();

  final params = Get.parameters;

  final ConnectService _connect = Connect(useToken: false);

  final TextEditingController authController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  Timer? _timer;

  @override
  void onInit() {
    state.data.value = GuestEmailVerification.fromJson(params);

    super.onInit();
  }

  @override
  void onReady() {
    _startTimer();

    super.onReady();
  }

  void _startTimer() {
    if(state.timeout.value != 59) {
      _timer?.cancel();
      state.timeout.value = 59;

      _updateTimer();
    } else {
      _updateTimer();
    }
  }

  void _updateTimer() {
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

    var response = await _connect.post(
      endpoint: "/auth/guest/email/ask",
      body: {
        "email_address": state.data.value.emailAddress,
      }
    );

    state.isResending.value = false;
    if(response.isOk) {
      notify.success(message: response.message);
      _startTimer();
      return;
    } else {
      notify.error(message: response.message);
      return;
    }
  }

  void verify({String? code}) async {
    if(code != null) {
      state.token.value = code;
    }

    if(state.token.value.isEmpty || state.token.value.length < 6) {
      notify.error(message: "Incorrect token");
      return;
    }

    state.isVerifying.value = true;
    var response = await _connect.post(
      endpoint: "/auth/guest/email/verify",
      body: {
        "email_address": state.data.value.emailAddress,
        "token": state.token.value,
      }
    );

    state.isVerifying.value = false;
    if(response.isOk) {
      _onSuccess();
    } else {
      notify.error(message: response.message);
      return;
    }
  }

  void _onSuccess() {
    if(state.data.value.becomeAUser) {
      GuestUpgradeLayout.open(guestId: state.data.value.guestId, linkId: state.data.value.linkId);
    } else {
      Navigate.all(GuestParentLayout.route);
    }
  }

  @override
  void onClose() {
    authController.dispose();
    focusNode.dispose();
    _timer?.cancel();

    super.onClose();
  }
}
