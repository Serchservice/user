import 'package:get/get.dart';
import 'package:user/library.dart';

class EmailSwitchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailSwitchController>(() => EmailSwitchController());
  }
}