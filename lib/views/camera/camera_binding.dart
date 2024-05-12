import 'package:get/get.dart';
import 'package:user/library.dart';

class CameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CameraLayoutController>(() => CameraLayoutController());
  }
}