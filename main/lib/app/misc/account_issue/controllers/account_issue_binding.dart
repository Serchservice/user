import 'package:user/library.dart';
import 'package:get/get.dart';

class AccountIssueBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountIssueController>(() => AccountIssueController());
  }
}