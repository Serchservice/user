import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:user/library.dart';

class PreferenceSelectorState {
  Rx<Gender> gender = Gender.any.obs;

  Rx<SecurityType> security = SecurityType.none.obs;

  Rx<ThemeType> theme = ThemeType.light.obs;

  Rx<ScheduleTime> schedule = ScheduleTime.thirtyMinutes.obs;

  Rx<PreferenceOption> preference = PreferenceOption.none.obs;

  RxBool isSaving = RxBool(false);
}