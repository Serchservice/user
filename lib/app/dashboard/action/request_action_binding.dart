import 'package:get/get.dart';
import 'package:user/library.dart';

class RequestActionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestActionController>(() => RequestActionController());
  }
}