import 'package:connectify_flutter/connectify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class EmailCheckerController extends GetxController {
  EmailCheckerController();
  final state = EmailCheckerState();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
    passwordController.dispose();
    super.onClose();
  }

  void verifyEmail(BuildContext context) async {
    CommonUtility.unfocus(context);

    if(formKey.currentState != null && formKey.currentState!.validate()) {
      state.isVerifying.value = true;
      var response = await _connect.get(endpoint: "/auth/email/check?email=${emailController.text.trim()}");
      state.isVerifying.value = false;
      if(response.isOk) {
        Navigate.to(LoginLayout.route, parameters: {
          "email_address": emailController.text.trim(),
          "name": response.data
        });
      } else if(response.isUserNotFound || response.isEmailNotVerified) {
        if(response.isEmailNotVerified) {
          notify.success(message: response.message);
        }
        if(state.referral.value.isNotEmpty) {
          Navigate.to(EmailVerificationLayout.route, parameters: {
            "email_address": emailController.text.trim(),
            "referral": state.referral.value
          });
        } else {
          Navigate.to(EmailVerificationLayout.route, parameters: {
            "email_address": emailController.text.trim()
          });
        }
      } else if(response.isCategoryNotSet) {
        Navigate.bottomSheet(sheet: BecomeAUserSheet(controller: this), route: "/auth/user/become");
        return;
      } else if(response.isProfileNotSet) {
        if(state.referral.value.isNotEmpty) {
          Navigate.to(SignupLayout.route, parameters: {
            "email_address": emailController.text.trim(),
            "referral": state.referral.value
          });
        } else {
          Navigate.to(SignupLayout.route, parameters: {
            "email_address": emailController.text.trim(),
          });
        }
      } else {
        notify.error(message: response.message);
        return;
      }
    } else {
      return;
    }
  }

  void becomeAUser(BuildContext context) async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    state.isVerifying.value = true;
    var response = await _connect.post(
        endpoint: "/auth/user/become",
        body: {
          "password": passwordController.text.trim(),
          "platform": Database.device.platform,
          "device": Database.device.toJson(),
          "email_address": emailController.text.trim(),
        }
    );
    state.isVerifying.value = false;
    if(response.isOk) {
      AuthResponse auth = AuthResponse.fromJson(response.data);
      Database.saveAuth(auth);
      Navigate.all(HomeLayout.route);
    } else if(response.isProfileNotSet) {
      if(state.referral.value.isNotEmpty) {
        Navigate.to(SignupLayout.route, parameters: {
          "email_address": emailController.text.trim(),
          "referral": state.referral.value
        });
      } else {
        Navigate.to(SignupLayout.route, parameters: {
          "email_address": emailController.text.trim()
        });
      }
    } else if(response.isEmailNotVerified) {
      if(state.referral.value.isNotEmpty) {
        Navigate.to(EmailVerificationLayout.route, parameters: {
          "email_address": emailController.text.trim(),
          "referral": state.referral.value
        });
      } else {
        Navigate.to(EmailVerificationLayout.route, parameters: {
          "email_address": emailController.text.trim()
        });
      }
    } else {
      notify.error(message: response.message);
      return;
    }
  }
}