import 'package:user/library.dart';
import 'package:get/get.dart';

class GuestPreferenceState {
  /// Current preference
  Rx<Preference> preference = Database.preference.obs;

  Rx<Preference> guestPreference = Database.guestPreference.obs;
}