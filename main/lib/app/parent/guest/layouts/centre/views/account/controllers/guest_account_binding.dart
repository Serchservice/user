import 'package:user/library.dart';
import 'package:get/get.dart';

class GuestAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuestAccountController>(() => GuestAccountController());
  }
}