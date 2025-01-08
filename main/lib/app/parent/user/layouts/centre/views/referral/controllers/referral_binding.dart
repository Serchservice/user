import 'package:user/library.dart';
import 'package:get/get.dart';

class ReferralBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReferralController>(() => ReferralController());
  }
}