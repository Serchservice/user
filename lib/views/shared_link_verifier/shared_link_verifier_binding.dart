import 'package:get/get.dart';
import 'package:user/library.dart';

class SharedLinkVerifierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SharedLinkVerifierController>(() => SharedLinkVerifierController());
  }
}