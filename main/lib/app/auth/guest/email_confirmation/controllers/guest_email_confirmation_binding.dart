import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestEmailConfirmationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuestEmailConfirmationController>(() => GuestEmailConfirmationController());
  }
}