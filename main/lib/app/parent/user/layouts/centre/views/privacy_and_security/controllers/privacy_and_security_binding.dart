import 'package:user/library.dart';
import 'package:get/get.dart';

class PrivacyAndSecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyAndSecurityController>(() => PrivacyAndSecurityController());
  }
}