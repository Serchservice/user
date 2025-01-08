import 'package:get/get.dart';
import 'package:user/library.dart';

class AccountUpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountUpdateController>(() => AccountUpdateController());
  }
}