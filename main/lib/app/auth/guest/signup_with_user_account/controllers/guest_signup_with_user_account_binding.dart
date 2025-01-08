import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestSignupWithUserAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuestSignupWithUserAccountController>(() => GuestSignupWithUserAccountController());
  }
}