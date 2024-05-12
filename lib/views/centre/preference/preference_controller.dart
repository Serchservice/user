import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class PreferenceController extends GetxController {
  PreferenceController();
  final state = PreferenceState();

  final Connect _connect = Connect();

  @override
  void onInit() {
    state.genderSelection.value = Database.setting.gender;
    getAppSetting();
    super.onInit();
  }

  void getAppSetting() async {
    try {
      var res = await _connect.get(endpoint: "/account/settings");
      ApiResponse response = ApiResponse.fromJson(res.data);
      if(response.isOk) {
        AppSetting setting = AppSetting.fromJson(response.data);
        Database.saveAppSetting(setting);
        state.genderSelection.value = setting.gender;
      }
    } on Exception catch (_) {}
  }

  final HomeController home = Get.find<HomeController>();

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