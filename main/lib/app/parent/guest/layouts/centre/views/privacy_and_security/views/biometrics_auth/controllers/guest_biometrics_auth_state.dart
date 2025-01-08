import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:user/library.dart';

class GuestBiometricsAuthState {
  /// Message
  RxString message = RxString("Place your finger on your sensor to activate");

  /// Whether this is login authentication
  RxBool isLogin = RxBool(false);

  /// Whether biometrics authentication is already enabled
  RxBool hasBiometrics = RxBool(false);

  /// Auth state
  Rx<BiometricAuthState> auth = BiometricAuthState.none.obs;

  /// Device has biometrics
  RxBool deviceHasBiometrics = RxBool(false);

  /// Biometric Sensors
  RxList<BiometricType> sensors = <BiometricType>[].obs;
}