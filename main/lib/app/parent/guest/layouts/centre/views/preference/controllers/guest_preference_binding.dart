import 'package:user/library.dart';
import 'package:get/get.dart';

class GuestPreferenceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuestPreferenceController>(() => GuestPreferenceController());
  }
}