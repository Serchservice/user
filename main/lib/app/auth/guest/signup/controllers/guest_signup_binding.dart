import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestSignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuestSignupController>(() => GuestSignupController());
  }
}