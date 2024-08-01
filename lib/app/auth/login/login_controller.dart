import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class LoginController extends GetxController {
  LoginController();
  final state = LoginState();

  final ConnectService _connect = Connect(useToken: false);
  final FirebaseMessagingService _messaging = FirebaseMessagingImplementation();

  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final params = Get.parameters;

  @override
  void onInit() {
    state.emailAddress.value = params["email_address"] ?? "";
    state.name.value = params["name"] ?? "";

    if(state.emailAddress.value.isEmpty) {
      redirect();
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
      var response = await _connect.post(
          endpoint: "/auth/user/login",
          body: {
            "password": passwordController.text.trim(),
            "platform": Database.device.platform,
            "device": Database.device.toJson(),
            "state": Database.address.state,
            "country": Database.address.country,
            "email_address": state.emailAddress.value,
          }
      );
      state.isVerifying.value = false;
      if(response.isOk) {
        AuthResponse auth = AuthResponse.fromJson(response.data);
        Database.saveAuth(auth);
        Database.savePreference(Database.preference.copyWith(active: auth.id));

        await _messaging.getFcmToken().then((token) async {
          if(token.isNotEmpty) {
            final ConnectService connect = Connect();
            await connect.patch(endpoint: "/account/fcm/update?token=$token", body: {});
          }
        });

        AnalyticsEngine.userLogin(
            "email",
            state.emailAddress.value,
            Database.device,
            Database.address
        );
        if(auth.hasMfa && !Database.preference.remember && (Database.preference.isMFA || Database.preference.isBoth || Database.preference.isNone)) {
          AuthWithMultiFactor.login();
        } else {
          Navigate.all(HomeLayout.route);
        }
      } else {
        notify.error(message: response.message);
        return;
      }
    } else {
      return;
    }
  }
}