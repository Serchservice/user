import 'package:user/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AccountUpdateController extends GetxController {
  AccountUpdateController();
  final state = AccountUpdateState();

  final ConnectService _connect = Connect();
  final ParentController home = ParentController.data;
  final AccountController account = AccountController.data;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  @override
  void onInit() {
    firstName.text = account.state.profile.value.firstName;
    lastName.text = account.state.profile.value.lastName;
    phoneNumber.text = account.state.profile.value.phoneInfo.phoneNumber;

    state.avatar.value = account.state.profile.value.avatar;
    state.gender.value = (account.state.profile.value.gender).toGender();
    state.isoCode.value = account.state.profile.value.phoneInfo.isoCode;

    super.onInit();
  }

  @override
  void onClose() {
    firstName.dispose();
    lastName.dispose();
    phoneNumber.dispose();

    super.onClose();
  }

  void sendUpdate() async {
    state.isLoading.value = true;

    var response = await _connect.patch(endpoint: "/profile/update", body: {
      "phone": {
        "phone_number": phoneNumber.text.trim(),
        "country_code": state.countryCode.value,
        "iso_code": state.isoCode.value,
        "country": state.country.value.name
      },
      "upload": {
        "path": state.selectedAvatar.value.path,
        "bytes": state.selectedAvatar.value.data,
        "media": state.selectedAvatar.value.media.type
      },
      "first_name": firstName.text.trim(),
      "last_name": lastName.text.trim(),
      "gender": state.gender.value.key,
    });

    state.isLoading.value = false;
    if(response.isOk) {
      Profile profile = Profile.fromJson(response.data);
      Database.saveAuth(Database.auth.copyWith(avatar: profile.avatar, firstName: profile.firstName, lastName: profile.lastName));

      home.state.avatar.value = profile.avatar;
      home.state.name.value = profile.name;
      home.state.firstName.value = profile.firstName;
      account.updateProfile(profile);

      Navigate.back();
    } else {
      notify.error(message: response.message);
    }
  }

  void changeAvatar() {
    MediaSelector.open(
      onReceived: (result) {
        Navigate.back();
        state.selectedAvatar.value = result;
        state.avatar.value = result.path;
      },
      title: "Pick your profile picture",
      route: "/centre/account/update/avatar"
    );
  }

  void pickGender(Gender value) {
    state.gender.value = value;
  }
}