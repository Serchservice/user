import 'package:get/get.dart';
import 'package:user/library.dart';

class LocationCheckerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationCheckerController>(() => LocationCheckerController());
  }
}