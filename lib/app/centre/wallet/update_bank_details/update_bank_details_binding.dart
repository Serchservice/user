import 'package:get/get.dart';
import 'package:user/library.dart';

class UpdateBankDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateBankDetailsController>(() => UpdateBankDetailsController());
  }
}