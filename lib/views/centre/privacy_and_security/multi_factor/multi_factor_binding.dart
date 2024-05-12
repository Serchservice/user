import 'package:get/get.dart';
import 'package:user/library.dart';

class MultiFactorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MultiFactorController>(() => MultiFactorController());
  }
}