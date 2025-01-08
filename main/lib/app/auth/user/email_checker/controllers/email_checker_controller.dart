import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class EmailCheckerController extends GetxController {
  EmailCheckerController();
  static EmailCheckerController get data => Get.find<EmailCheckerController>();

  final state = EmailCheckerState();

  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ConnectService _connect = Connect(useToken: false);

  final params = Get.parameters;

  @override
  void onInit() {
    state.referral.value = params["referral"] ?? "";

    super.onInit();
  }

  @override
  void onReady() {
    launchDevice();

    super.onReady();
  }

  void toggle() => state.isVisible.toggle();

  @override
  void onClose() {
    emailController.dispose();

    super.onClose();
  }

  void verifyEmail(BuildContext context) async {
    CommonUtility.unfocus(context);

    if(formKey.currentState != null && formKey.currentState!.validate()) {
      state.isVerifying.value = true;
      var response = await _connect.get(endpoint: "/auth/email/check?email=${emailController.text.trim()}");
      state.isVerifying.value = false;

      if(response.isOk) {
        LoginLayout.to(emailAddress: emailController.text.trim(), name: response.data);
      } else if(response.isUserNotFound || response.isEmailNotVerified) {
        if(response.isEmailNotVerified) {
          notify.success(message: response.message);
        }

        EmailVerificationLayout.to(emailAddress: emailController.text.trim(), referral: state.referral.value);
      } else if(response.isSignupIncomplete) {
        EmailSwitchLayout.to(emailAddress: emailController.text.trim(), referral: state.referral.value);
        return;
      } else if(response.isProfileNotSet) {
        SignupLayout.open(emailAddress: emailController.text.trim(), referral: state.referral.value);
      } else {
        notify.error(message: response.message);
        return;
      }
    } else {
      return;
    }
  }
}