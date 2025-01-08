import 'package:user/library.dart';
import 'package:get/get.dart';

class SpeakWithSerchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpeakWithSerchController>(() => SpeakWithSerchController());
  }
}