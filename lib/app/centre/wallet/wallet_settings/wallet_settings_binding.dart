import 'package:get/get.dart';
import 'package:user/library.dart';

class WalletSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletSettingsController>(() => WalletSettingsController());
  }
}