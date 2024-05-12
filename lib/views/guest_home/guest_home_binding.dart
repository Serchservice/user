import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuestHomeController>(() => GuestHomeController());
  }
}