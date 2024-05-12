import 'package:get/get.dart';
import 'package:user/library.dart';

class BiometricsState {
  /// Has biometrics enabled
  Rx<Preference> preference = Database.preference.obs;
}