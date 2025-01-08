import 'package:user/library.dart';
import 'package:get/get.dart';

class GuestBiometricsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuestBiometricsController>(() => GuestBiometricsController());
  }
}