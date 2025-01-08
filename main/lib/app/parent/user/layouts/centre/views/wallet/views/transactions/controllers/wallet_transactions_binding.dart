import 'package:get/get.dart';
import 'package:user/library.dart';

class WalletTransactionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletTransactionsController>(() => WalletTransactionsController());
  }
}