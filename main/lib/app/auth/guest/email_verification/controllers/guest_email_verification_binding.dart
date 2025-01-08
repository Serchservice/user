import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestEmailVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuestEmailVerificationController>(() => GuestEmailVerificationController());
  }
}