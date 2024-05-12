import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class SignupController extends GetxController {
  SignupController();
  final state = SignupState();

  final Connect _connect = Connect(useToken: false);
  final RemoteMessagingService _remoteMessaging = RemoteMessagingImplementation();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController referralController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final params = Get.parameters;

  @override
  void onInit() {
    state.emailAddress.value = params["email_address"] ?? "";
    state.referral.value = params["referral"] ?? "";

    if(state.emailAddress.value.isEmpty) {
      SnackBars.top(message: "Unformatted email address", type: Snackbar.error);
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigate.back();
      });
    }
    super.onInit();
  }

  @override
  void onReady() async {
    if(state.referral.value.isNotEmpty) {
      referralController.text = state.referral.value;
    }
    referralController.addListener(() { });

    if(Database.countries.isNotEmpty) {
      Country country = Database.countries.firstWhere((country) {
        return Database.address.country == country.name;
      },
        orElse: () => Database.countries.first
      );
      state.isoCode.value = country.code;
      state.countryCode.value = country.dialCode;
      state.country.value = country.name;
    }
    super.onReady();
  }

  void toggle() => state.isVisible.toggle();

  void pickGender(String gender) {
    state.gender.value = gender;
  }

  void save(BuildContext context) async {
    if(formkey.currentState != null && formkey.currentState!.validate()) {
      if(state.gender.value.isEmpty) {
        SnackBars.top(message: "You need to pick a gender for your profile.", type: Snackbar.error);
        return;
      } else {
        state.isSaving.value = true;

        if(state.country.value.isEmpty) {
          state.country.value = Database.address.country;
        }

        if(state.referral.isEmpty && referralController.text.isNotEmpty) {
          validateReferral(context);
        } else {
          signup();
        }
      }
    } else {
      return;
    }
  }

  void validateReferral(BuildContext context) async {
    try {
      var response = await _connect.get(endpoint: "/referral/program/verify/code?code=${referralController.text.trim()}");
      state.isSaving.value = false;
      ApiResponse apiResponse = ApiResponse.fromJson(response.data);
      if(apiResponse.isOk) {
        ReferralProgram programResponse = ReferralProgram.fromJson(apiResponse.data);
        Navigate.bottomSheet(
          sheet: ReferralProgramSheet(
            program: programResponse,
            onContinue: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              signup();
            }
          ),
          route: "/referral/program/${programResponse.data.referralCode}"
        );
      } else {
        SnackBars.top(message: apiResponse.message, type: Snackbar.error);
        return;
      }
    } on Exception catch (e) {
      state.isSaving.value = false;
      Connect.showError(e);
    }
  }

  void signup() async {
    state.isSaving.value = true;
    final fcmToken = await _remoteMessaging.getFcmToken();
    try {
      var response = await _connect.post(
        endpoint: "/auth/user/signup",
        body: {
          "first_name": firstNameController.text.trim(),
          "last_name": lastNameController.text.trim(),
          "gender": state.gender.value.toUpperCase(),
          "phone_information": {
            "phone_number": phoneNumberController.text.trim(),
            "country_code": state.countryCode.value,
            "iso_code": state.isoCode.value,
            "country": state.country.value
          },
          "password": passwordController.text.trim(),
          "fcm_token": fcmToken,
          "email_address": state.emailAddress.value,
          "referral": referralController.text.trim(),
          "device": Database.device.toJson(),
        }
      );
      state.isSaving.value = false;
      ApiResponse apiResponse = ApiResponse.fromJson(response.data);
      if(apiResponse.isOk) {
        AuthResponse authResponse = AuthResponse.fromJson(apiResponse.data);
        Database.saveAuth(authResponse);
        Navigate.all(HomeLayout.route);
      } else {
        state.referral.value = "";
        SnackBars.top(message: apiResponse.message, type: Snackbar.error);
        return;
      }
    } on Exception catch (e) {
      state.isSaving.value = false;
      Connect.showError(e);
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    referralController.dispose();
    phoneNumberController.dispose();
    super.onClose();
  }
}