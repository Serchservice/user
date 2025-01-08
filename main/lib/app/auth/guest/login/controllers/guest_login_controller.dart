import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestLoginController extends GetxController {
  GuestLoginController();
  final state = GuestLoginState();

  final ConnectService _connect = Connect(useToken: false);

  final params = Get.parameters;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    state.link.value = params["link"] ?? "";
    state.linkId.value = params["link_id"] ?? "";

    super.onInit();
  }

  bool get hasLink => state.link.value.isNotEmpty && state.linkId.value.isNotEmpty;

  @override
  void onClose() {
    linkController.dispose();
    emailController.dispose();

    super.onClose();
  }

  Map<String, dynamic> _getRequestBody() {
    Map<String, dynamic> data = {
      "email_address": emailController.text.trim(),
      "state": Database.address.state,
      "country": Database.address.country,
    };

    if(hasLink) {
      data.putIfAbsent("token", () => "");
      data.putIfAbsent("link", () => state.link.value);
      data.putIfAbsent("link_id", () => state.linkId.value);
    } else {
      data.putIfAbsent("link", () => linkController.text.trim());
    }

    return data;
  }

  void login(BuildContext context) async {
    CommonUtility.unfocus(context);

    if(formKey.currentState != null && formKey.currentState!.validate()) {
      state.isVerifying.value = true;

      var response = await _connect.post(endpoint: "/auth/guest/login", body: _getRequestBody());

      state.isVerifying.value = false;
      if(response.isOk) {
        Guest guest = Guest.fromJson(response.data);
        Database.saveGuest(guest);
        Database.savePreference(Database.preference.copyWith(active: guest.link.linkId));

        Navigate.all(GuestParentLayout.route);
      } else {
        notify.error(message: response.message);
        return;
      }
    } else {
      return;
    }
  }
}