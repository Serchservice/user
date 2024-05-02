import 'package:get/get.dart';
import 'package:user/library.dart';

class AccountIssueController extends GetxController {
  AccountIssueController();
  final state = AccountIssueState();

  final param = Get.arguments;

  @override
  void onInit() {
    if(param != null) {
      state.message.value = param[0] ?? "At the moment, there are issues involved with this Serch account."
        " If you feel like this is an error on our side, contact the Serch team to fix it,"
        " Otherwise, we suggest you take the necessary required steps to get back on track.";
    } else {
      state.message.value = "At the moment, there are issues involved with this Serch account."
      " If you feel like this is an error on our side, contact the Serch team to fix it,"
      " Otherwise, we suggest you take the necessary required steps to get back on track.";
    }
    super.onInit();
  }
}