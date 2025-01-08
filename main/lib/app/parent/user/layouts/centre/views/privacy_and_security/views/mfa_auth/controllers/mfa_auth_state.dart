import 'package:get/get.dart';
import 'package:user/library.dart';

class MfaAuthState {
  /// Authentication mode
  Rx<MfaAuth> authMode = MfaAuth.login.obs;

  /// Is verifying token
  RxBool isVerifying = RxBool(false);

  /// Code mode selected
  RxBool isRecovery = RxBool(false);

  /// Token
  RxString token = RxString("");
}