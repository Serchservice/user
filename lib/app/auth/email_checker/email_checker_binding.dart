import 'package:get/get.dart';
import 'package:user/library.dart';

class EmailCheckerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailCheckerController>(() => EmailCheckerController());
  }
}