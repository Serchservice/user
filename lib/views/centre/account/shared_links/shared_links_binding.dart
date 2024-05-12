import 'package:get/get.dart';
import 'package:user/library.dart';

class SharedLinksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SharedLinksController>(() => SharedLinksController());
  }
}