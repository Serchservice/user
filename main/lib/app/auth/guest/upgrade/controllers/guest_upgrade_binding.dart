import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestUpgradeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuestUpgradeController>(() => GuestUpgradeController());
  }
}