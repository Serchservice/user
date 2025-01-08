import 'package:user/library.dart';
import 'package:get/get.dart';

class AppUpdatesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppUpdatesController>(() => AppUpdatesController());
  }
}