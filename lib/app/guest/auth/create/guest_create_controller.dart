import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestCreateController extends GetxController {
  GuestCreateController();
  final state = GuestCreateState();

  final ConnectService _connect = Connect(useToken: false);
  final FirebaseMessagingService _remoteNotification = FirebaseMessagingImplementation();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final params = Get.parameters;

  @override
  void onInit() {
    state.link.value = params["link"] ?? "";
    state.linkId.value = params["link_id"] ?? "";

    super.onInit();
  }

  @override
  void onReady() {
    if(state.link.value.isEmpty) {
      // Toast.bottom(message: "Unformatted shared link");
      goback();
    }
    super.onReady();
  }

  void goback() async {
    await Future.delayed(const Duration(milliseconds: 800), () {
      Navigate.back();
    });
  }

  void pickGender(String gender) {
    state.gender.value = gender;
  }

  void changeAvatar() {
    RouteNavigator.openMedia(
      onReceived: (result) {
        Navigate.back();
        state.avatar.value = result.path;
        state.media.value = result;
      },
      galleryParam: {
        "isVideo": "false",
        "title": "Pick your avatar"
      },
      route: "/auth/guest/create/avatar"
    );
  }

  void save(BuildContext context) async {
    CommonUtility.unfocus(context);
    if(formkey.currentState != null && formkey.currentState!.validate()) {
      if(state.gender.value.isEmpty) {
        notify.error(message: "You need to pick a gender for your profile.");
        return;
      } else {
        state.isSaving.value = true;
        final fcmToken = await _remoteNotification.getFcmToken();
        var response = await _connect.post(
            endpoint: "/auth/guest/create",
            body: {
              "first_name": firstNameController.text.trim(),
              "last_name": lastNameController.text.trim(),
              "gender": state.gender.value.toUpperCase(),
              "email_address": emailAddressController.text.trim(),
              "phone_number": phoneNumberController.text.trim(),
              "link": state.link.value,
              "link_id": state.linkId.value,
              "upload": {
                "path": state.media.value.path,
                "bytes": state.media.value.data,
                "media": state.media.value.media.type
              },
              "fcm_token": fcmToken,
              "state": Database.address.state,
              "country": Database.address.country,
              "device": Database.device.toJson(),
            }
        );
        state.isSaving.value = false;
        if(response.isOk) {
          Guest guest = Guest.fromJson(response.data);
          Database.saveGuest(guest);
          Database.savePreference(Database.preference.copyWith(active: guest.link.linkId));
          if(guest.confirmed) {
            Navigate.all(GuestHomeLayout.route);
          } else {
            AskToVerifySheet.open(
              emailAddress: guest.emailAddress,
              onSuccess: () => Navigate.all(GuestHomeLayout.route),
            );
          }
        } else {
          notify.error(message: response.message);
          return;
        }
      }
    } else {
      return;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailAddressController.dispose();
    phoneNumberController.dispose();
    super.onClose();
  }
}