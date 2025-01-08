import 'package:user/library.dart';
import 'package:get/get.dart';

class PreferenceState {
  /// Current preference
  Rx<Preference> preference = Database.preference.obs;

  /// Current settings
  Rx<AppSetting> settings = Database.setting.obs;

  /// Trip gender selection
  Rx<Gender> genderSelection = Gender.none.obs;
}