import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class PreferenceController extends GetxController {
  PreferenceController();
  final state = PreferenceState();

  final ConnectService _connect = Connect();
  final HomeController home = HomeController.data;

  @override
  void onInit() {
    state.genderSelection.value = Database.setting.gender;
    getAppSetting();
    super.onInit();
  }

  void getAppSetting() async {
    var response = await _connect.get(endpoint: "/account/settings");
    if(response.isOk) {
      AppSetting setting = AppSetting.fromJson(response.data);
      Database.saveAppSetting(setting);
      state.genderSelection.value = setting.gender;
    }
  }

  void updateShowOnlyCertified(bool value) async {
    state.settings.value = state.settings.value.copyWith(showOnlyCertified: value);
    var response = await _connect.patch(endpoint: "/account/settings/update", body: {
      "show_only_certified": value
    });

    if(response.isOk) {
      AppSetting setting = AppSetting.fromJson(response.data);
      Database.saveAppSetting(setting);
      state.settings.value = setting;
    }
  }

  void updateShowOnlyVerified(bool value) async {
    state.settings.value = state.settings.value.copyWith(showOnlyVerified: value);
    var response = await _connect.patch(endpoint: "/account/settings/update", body: {
      "show_only_verified": value
    });

    if(response.isOk) {
      AppSetting setting = AppSetting.fromJson(response.data);
      Database.saveAppSetting(setting);
      state.settings.value = setting;
    }
  }

  void updateTheme(ThemeType theme) {
    if(theme == ThemeType.light) {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.dark);
    }
    state.preference.value = state.preference.value.copyWith(theme: theme);
    Database.savePreference(state.preference.value);
    home.state.theme.value = theme;
  }
}