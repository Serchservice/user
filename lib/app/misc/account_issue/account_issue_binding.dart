import 'package:get/get.dart';
import 'package:user/library.dart';

class AccountIssueBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountIssueController>(() => AccountIssueController());
  }
}