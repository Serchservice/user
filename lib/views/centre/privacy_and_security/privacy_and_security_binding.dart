import 'package:get/get.dart';
import 'package:user/library.dart';

class PrivacyAndSecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyAndSecurityController>(() => PrivacyAndSecurityController());
  }
}