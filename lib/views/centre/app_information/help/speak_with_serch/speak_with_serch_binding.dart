import 'package:get/get.dart';
import 'package:user/library.dart';

class SpeakWithSerchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpeakWithSerchController>(() => SpeakWithSerchController());
  }
}