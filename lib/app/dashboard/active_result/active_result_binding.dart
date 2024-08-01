import 'package:get/get.dart';
import 'package:user/library.dart';

class ActiveResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActiveResultController>(() => ActiveResultController());
  }
}