import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuestCreateController>(() => GuestCreateController());
  }
}