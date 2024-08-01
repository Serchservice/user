import 'package:get/get.dart';
import 'package:user/library.dart';

class WebBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebController>(() => WebController());
  }
}