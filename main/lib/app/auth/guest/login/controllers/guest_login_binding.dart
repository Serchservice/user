import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuestLoginController>(() => GuestLoginController());
  }
}