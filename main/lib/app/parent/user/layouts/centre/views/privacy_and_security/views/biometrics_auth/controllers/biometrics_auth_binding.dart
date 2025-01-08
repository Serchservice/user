import 'package:user/library.dart';
import 'package:get/get.dart';

class BiometricsAuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BiometricsAuthController>(() => BiometricsAuthController());
  }
}