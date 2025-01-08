import 'package:get/get.dart';
import 'package:user/library.dart';

class CallBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CallController>()) {
      Get.put(CallController(), permanent: true);
    }

    try {
      if(!HomeController.data.initialized) {
        Get.lazyPut<HomeController>(() => HomeController());
      }
    } catch (_) {
      Get.lazyPut<HomeController>(() => HomeController());
    }
  }
}