import 'package:get/get.dart';
import 'package:user/library.dart';

class WalletUpdateBankDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletUpdateBankDetailsController>(() => WalletUpdateBankDetailsController());
  }
}