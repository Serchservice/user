import 'package:get/get.dart';
import 'package:user/library.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if(!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(() => HomeController());
    }

    CallConfiguration.bind();
  }
}