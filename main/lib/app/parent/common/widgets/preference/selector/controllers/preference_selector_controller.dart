import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class PreferenceSelectorController extends GetxController {
  final Gender selectedGender;
  final ThemeType selectedTheme;
  final ScheduleTime selectedSchedule;
  final PreferenceOption selectedPreference;
  final SecurityType selectedSecurity;
  final Function(Gender, ThemeType, PreferenceOption, ScheduleTime, SecurityType) onChanged;

  PreferenceSelectorController({
    required this.selectedSchedule,
    required this.selectedGender,
    required this.selectedTheme,
    required this.selectedPreference,
    required this.selectedSecurity,
    required this.onChanged
  });

  final state = PreferenceSelectorState();
  final ConnectService _connect = Connect();

  @override
  void onInit() {
    state.gender.value = selectedGender;
    state.theme.value = selectedTheme;
    state.schedule.value = selectedSchedule;
    state.preference.value = selectedPreference;
    state.security.value = selectedSecurity;

    super.onInit();
  }

  void _updateGender() async {
    state.isSaving.value = true;

    String url = "/account/settings/change/trip/gender?gender=${state.gender.value.key}";
    var response = await _connect.patch(endpoint: url);

    state.isSaving.value = false;
    if(response.isOk) {
      Navigate.back();
      _onChanged();
    } else {
      return;
    }
  }

  void _onChanged() {
    onChanged.call(state.gender.value, state.theme.value, state.preference.value, state.schedule.value, state.security.value);
  }

  void onSave(BuildContext context) {
    if(state.gender.value != selectedGender) {
      _updateGender();
    } else {
      Navigator.pop(context);
      _onChanged();
    }
  }

  void updatePreference(PreferenceOption preference) {
    state.preference.value = preference;
  }

  void updateScheduleTime(ScheduleTime schedule) {
    state.schedule.value = schedule;
  }

  void updateSecurityType(SecurityType security) {
    state.security.value = security;
  }

  void updateGender(Gender gender) {
    state.gender.value = gender;
  }

  void updateThemeType(ThemeType theme) {
    state.theme.value = theme;
  }
}