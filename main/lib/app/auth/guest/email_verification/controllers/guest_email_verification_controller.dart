import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestEmailVerificationController extends GetxController {
  GuestEmailVerificationController();
  final state = GuestEmailVerificationState();

  final params = Get.parameters;

  final ConnectService _connect = Connect(useToken: false);

  @override
  void onInit() {
    state.data.value = GuestEmailVerification.fromJson(params);

    super.onInit();
  }

  void send(BuildContext context) async {
    CommonUtility.unfocus(context);

    state.isVerifying.value = true;
    var response = await _connect.post(
      endpoint: "/auth/guest/email/ask",
      body: {
        "email_address": state.data.value.emailAddress
      }
    );
    state.isVerifying.value = false;

    if(response.isOk) {
      notify.success(message: response.message);
      GuestEmailConfirmationLayout.off(state.data.value);
    } else {
      notify.error(message: response.message);
      return;
    }
  }
}