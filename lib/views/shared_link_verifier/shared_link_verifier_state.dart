import 'package:get/get.dart';
import 'package:user/library.dart';

class SharedLinkVerifierState {
  /// Message to show on screen
  RxString message = "Checking link...".obs;

  /// Whether to show the loading widget or not
  RxBool showLoading = true.obs;

  /// Shared Link Data
  Rx<SharedLinkData> data = SharedLinkData.empty().obs;
}