import 'package:get/get.dart';
import 'package:user/library.dart';

class AppUpdatesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppUpdatesController>(() => AppUpdatesController());
  }
}