import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestSignupWithUserAccountController extends GetxController {
  GuestSignupWithUserAccountController();
  final state = GuestSignupWithUserAccountState();

  final params = Get.parameters;
  final ConnectService _connect = Connect(useToken: false);

  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    state.link.value = params["link"] ?? "";

    super.onInit();
  }

  @override
  void onClose() {
    passwordController.dispose();

    super.onClose();
  }

  void changeAvatar() {
    MediaSelector.open(
      onReceived: (result) {
        Navigate.back();

        state.media.value = result;
        state.avatar.value = result.path;
      },
      title: "Pick your avatar",
      route: "/auth/guest/signup/user/avatar"
    );
  }

  void create(BuildContext context) async {
    CommonUtility.unfocus(context);

    if(formKey.currentState != null && formKey.currentState!.validate()) {
      state.isVerifying.value = true;
      var response = await _connect.post(
        endpoint: "/auth/guest/create/existing",
        body: {
          "password": passwordController.text.trim(),
          "link": state.link.value,
          "device": Database.device.toJson(),
          "state": Database.address.state,
          "country": Database.address.country,
          "upload": {
            "path": state.media.value.path,
            "bytes": state.media.value.data,
            "media": state.media.value.media.type
          },
        }
      );

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