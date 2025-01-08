import 'package:user/library.dart';
import 'package:get/get.dart';

class GuestBiometricsState {
  /// Has biometrics enabled
  Rx<Preference> preference = Database.guestPreference.obs;
}