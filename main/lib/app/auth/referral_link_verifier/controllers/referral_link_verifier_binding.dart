import 'package:get/get.dart';
import 'package:user/library.dart';

class ReferralLinkVerifierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReferralLinkVerifierController>(() => ReferralLinkVerifierController());
  }
}