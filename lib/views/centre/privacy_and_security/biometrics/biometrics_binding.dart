import 'package:get/get.dart';
import 'package:user/library.dart';

class BiometricsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BiometricsController>(() => BiometricsController());
  }
}