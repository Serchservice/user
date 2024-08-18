import 'package:get/get.dart';
import 'package:user/library.dart';

class MfaAuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MfaAuthController>(() => MfaAuthController());
  }
}