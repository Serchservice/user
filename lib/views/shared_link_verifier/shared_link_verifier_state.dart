import 'package:get/get.dart';

class SharedLinkVerifierState {
  /// Message to show on screen
  RxString message = "Checking link...".obs;

  /// Whether to show the loading widget or not
  RxBool showLoading = true.obs;
}