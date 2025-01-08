import 'package:connectify_flutter/connectify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class EmailSwitchController extends GetxController {
  EmailSwitchController();
  final state = EmailSwitchState();

  final params = Get.parameters;
  final ConnectService _connect = Connect(useToken: false);

  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    state.emailAddress.value = params["email_address"] ?? "";
    state.referral.value = params["referral"] ?? "";

    super.onInit();
  }

  String get message => "${state.emailAddress.value} was used to start an account creation process as"
      " a Serch provider. If this is you, you can switch the profile to a User";

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
        "email_address": state.emailAddress.value
      }
    );

    state.isVerifying.value = false;
    if(response.isOk) {
      AuthResponse auth = AuthResponse.fromJson(response.data);
      Database.saveAuth(auth);

      Navigate.all(ParentLayout.route);
    } else if(response.isProfileNotSet) {
      SignupLayout.open(emailAddress: state.emailAddress.value, referral: state.referral.value);
    } else if(response.isEmailNotVerified) {
      EmailVerificationLayout.to(emailAddress: state.emailAddress.value, referral: state.referral.value);
    } else {
      notify.error(message: response.message);
      return;
    }
  }
}