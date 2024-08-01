import 'package:get/get.dart';
import 'package:user/library.dart';

class PreferenceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreferenceController>(() => PreferenceController());
  }
}