import 'package:get/get.dart';
import 'package:user/library.dart';

class AppInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppInformationController>(() => AppInformationController());
  }
}