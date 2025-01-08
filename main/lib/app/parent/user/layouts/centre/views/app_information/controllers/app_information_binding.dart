import 'package:user/library.dart';
import 'package:get/get.dart';

class AppInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppInformationController>(() => AppInformationController());
  }
}