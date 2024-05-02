import 'package:get/get.dart';
import 'package:user/library.dart';

class ResetPasswordConfirmationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordConfirmationController>(() => ResetPasswordConfirmationController());
  }
}