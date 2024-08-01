import 'package:get/get.dart';
import 'package:user/library.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController());

    try {
      if(!HomeController.data.initialized) {
        Get.lazyPut<HomeController>(() => HomeController());
      }
    } catch (_) {
      Get.lazyPut<HomeController>(() => HomeController());
    }
  }
}