import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class EmailCheckerController extends GetxController {
  EmailCheckerController();
  final state = EmailCheckerState();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Connect _connect = Connect(useToken: false);

  final params = Get.parameters;

  @override
  void onInit() {
    state.referral.value = params["referral"] ?? "";
    super.onInit();
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
      try {
        var response = await _connect.get(endpoint: "/auth/email/check?email=${emailController.text.trim()}");
        state.isVerifying.value = false;
        var apiResponse = ApiResponse.fromJson(response.data);
        if(apiResponse.isOk) {
          Navigate.to(LoginLayout.route, parameters: {
            "email_address": emailController.text.trim(),
            "name": apiResponse.data
          });
        } else if(apiResponse.isUserNotFound || apiResponse.isEmailNotVerified) {
          if(apiResponse.isEmailNotVerified) {
            SnackBars.top(message: apiResponse.message, type: Snackbar.error);
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
        } else if(apiResponse.isCategoryNotSet) {
          Navigate.bottomSheet(sheet: BecomeAUserSheet(controller: this), route: "/auth/user/become");
          return;
        } else if(apiResponse.isProfileNotSet) {
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
          SnackBars.top(message: apiResponse.message, type: Snackbar.error);
          return;
        }
      } on Exception catch (e) {
        SnackBars.top(message: "An error occurred. Please try again.", type: Snackbar.error);
        Connect.showError(e);
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
    try {
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
      var apiResponse = ApiResponse.fromJson(response.data);
      if(apiResponse.isOk) {
        AuthResponse response = AuthResponse.fromJson(apiResponse.data);
        Database.saveAuth(response);
        Navigate.all(HomeLayout.route);
      } else if(apiResponse.isProfileNotSet) {
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
      } else if(apiResponse.isEmailNotVerified) {
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
        SnackBars.top(message: apiResponse.message, type: Snackbar.error);
        return;
      }
    } on Exception catch (e) {
      state.isVerifying.value = false;
      Connect.showError(e);
    }
  }
}