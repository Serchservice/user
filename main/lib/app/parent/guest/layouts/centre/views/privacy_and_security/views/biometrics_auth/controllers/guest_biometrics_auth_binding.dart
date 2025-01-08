import 'package:user/library.dart';
import 'package:get/get.dart';

class GuestBiometricsAuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuestBiometricsAuthController>(() => GuestBiometricsAuthController());
  }
}