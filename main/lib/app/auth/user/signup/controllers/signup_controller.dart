import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectify_flutter/connectify_flutter.dart';
import 'package:user/library.dart';

class SignupController extends GetxController {
  SignupController();
  final state = SignupState();

  final ConnectService _connect = Connect(useToken: false);
  final EndToEndEncryptionService _e2eeService = EndToEndEncryption();
  final FirebaseMessagingService _notification = FirebaseMessagingImplementation();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController referralController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final params = Get.parameters;

  @override
  void onInit() {
    state.emailAddress.value = params["email_address"] ?? "";
    state.referral.value = params["referral"] ?? "";

    if(state.emailAddress.value.isEmpty) {
      redirect();
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
    if(formKey.currentState != null && formKey.currentState!.validate()) {
      if(state.gender.value.isEmpty) {
        notify.warn(message: "You need to pick a gender for your profile.");
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
    var response = await _connect.get(endpoint: "/referral/program/verify/code?code=${referralController.text.trim()}");
    state.isSaving.value = false;
    if(response.isOk) {
      ReferralProgram programResponse = ReferralProgram.fromJson(response.data);
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
        route: "/referral/program/${programResponse.referralCode}",
        isScrollable: true
      );
    } else {
      notify.error(message: response.message);
      return;
    }
  }

  void signup() async {
    state.isSaving.value = true;
    final fcmToken = await _notification.getFcmToken();
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
        "state": Database.address.state,
        "country": Database.address.country,
      }
    );

    state.isSaving.value = false;
    if(response.isOk) {
      AuthResponse auth = AuthResponse.fromJson(response.data);
      Database.saveAuth(auth);
      Database.savePreference(Database.preference.copyWith(active: auth.id));
      AnalyticsEngine.userSignup(
        "email",
        state.emailAddress.value,
        Database.device,
        Database.address
      );

      _e2eeService.generateKeyPair(passwordController.text.trim(), shouldSendUpdateToServer: true);
      Navigate.all(ParentLayout.route);
    } else {
      state.referral.value = "";
      notify.error(message: response.message);
      return;
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