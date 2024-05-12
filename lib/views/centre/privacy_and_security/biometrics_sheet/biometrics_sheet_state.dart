import 'package:flutter_local_auth_invisible/flutter_local_auth_invisible.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class BiometricsSheetState {
  /// Message
  RxString message = RxString("Place your finger on your sensor to activate");

  /// Auth state
  Rx<BiometricAuthState> auth = BiometricAuthState.none.obs;

  /// Device has biometrics
  RxBool deviceHasBiometrics = RxBool(false);

  /// Biometric Sensors
  RxList<BiometricType> sensors = <BiometricType>[].obs;
}