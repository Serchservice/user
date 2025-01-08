import 'package:get/get.dart';
import 'package:user/library.dart';

class RequestEntryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestEntryController>(() => RequestEntryController());
  }
}