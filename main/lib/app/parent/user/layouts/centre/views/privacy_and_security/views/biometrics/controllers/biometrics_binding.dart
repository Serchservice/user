import 'package:user/library.dart';
import 'package:get/get.dart';

class BiometricsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BiometricsController>(() => BiometricsController());
  }
}