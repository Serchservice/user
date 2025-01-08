import 'package:user/library.dart';
import 'package:get/get.dart';

class BiometricsState {
  /// Has biometrics enabled
  Rx<Preference> preference = Database.preference.obs;
}