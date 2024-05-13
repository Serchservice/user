import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestHomeController extends GetxController {
  GuestHomeController();
  final state = GuestHomeState();

  final CommonApiService _apiService = CommonApi();

  @override
  void onInit() {
    _apiService.fetchAccounts();
    super.onInit();
  }

  void selectRoute(int index) {
    state.routeIndex.value = index;
    update();
  }

  void updateTheme(ThemeType theme) {
    if(theme == ThemeType.light) {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.dark);
    }
    state.preference.value = state.preference.value.copyWith(theme: theme);
    Database.savePreference(state.preference.value);
    state.theme.value = theme;
  }

  void confirmEmail() async {
    if(state.guest.value.confirmed) {
      GuestBecomeUser.open(
        guestId: state.guest.value.id,
        linkId: state.guest.value.link.linkId
      );
    } else {
      AskToVerifySheet.open(
        emailAddress: state.guest.value.emailAddress,
        onSuccess: () => GuestBecomeUser.open(
          guestId: state.guest.value.id,
          linkId: state.guest.value.link.linkId
        ),
      );
    }
  }
}