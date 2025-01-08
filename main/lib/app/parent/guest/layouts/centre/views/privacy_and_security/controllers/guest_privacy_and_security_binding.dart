import 'package:user/library.dart';
import 'package:get/get.dart';

class GuestPrivacyAndSecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuestPrivacyAndSecurityController>(() => GuestPrivacyAndSecurityController());
  }
}