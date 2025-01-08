import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestUpgradeController extends GetxController {
  GuestUpgradeController();
  final state = GuestUpgradeState();

  final params = Get.parameters;

  final ConnectService _connect = Connect(useToken: false);

  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();

  @override
  void onInit() {
    state.guestId.value = params["guest_id"] ?? "";
    state.linkId.value = params["link_id"] ?? "";

    if(Database.countries.isNotEmpty) {
      Country current = Database.countries.firstWhere((country) {
        return Database.address.country == country.name;
      }, orElse: () => Database.countries.first);

      state.isoCode.value = current.code;
      state.country.value = current.name;
      state.countryCode.value = current.dialCode;
    }

    super.onInit();
  }

  @override
  void onClose() {
    passwordController.dispose();
    phoneController.dispose();

    super.onClose();
  }

  void becomeAUser(BuildContext context) async {
    CommonUtility.unfocus(context);

    if(formKey.currentState != null && formKey.currentState!.validate()) {
      state.isLoading.value = true;

      var response = await _connect.post(
        endpoint: "/guest/user/become",
        body: {
          "password": passwordController.text.trim(),
          "link_id": state.linkId.value,
          "guest_id": state.guestId.value,
          "device": Database.device.toJson(),
          "phone_information": {
            "phone_number": phoneController.text.trim(),
            "country_code": state.countryCode.value,
            "iso_code": state.isoCode.value,
            "country": state.country.value,
          },
        }
      );

      state.isLoading.value = false;

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