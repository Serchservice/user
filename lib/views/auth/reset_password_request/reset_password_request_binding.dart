import 'package:get/get.dart';
import 'package:user/library.dart';

class ResetPasswordRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordRequestController>(() => ResetPasswordRequestController());
  }
}