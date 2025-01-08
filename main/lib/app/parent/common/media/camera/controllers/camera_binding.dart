import 'package:user/library.dart';
import 'package:get/get.dart';

class CameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CameraLayoutController>(() => CameraLayoutController());
  }
}