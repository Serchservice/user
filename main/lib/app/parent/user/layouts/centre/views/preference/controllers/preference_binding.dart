import 'package:user/library.dart';
import 'package:get/get.dart';

class PreferenceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreferenceController>(() => PreferenceController());
  }
}