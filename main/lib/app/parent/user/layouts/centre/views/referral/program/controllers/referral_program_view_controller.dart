import 'package:user/library.dart';
import 'package:get/get.dart';

class ReferralProgramViewController extends GetxController {
  ReferralProgramViewController();
  final state = ReferralProgramViewState();

  final ConnectService _connect = Connect();

  @override
  void onInit() {
    _fetchProgram();

    super.onInit();
  }

  void _fetchProgram() async {
    state.isFetching.value = true;
    var response = await _connect.get(endpoint: "/referral/program");

    if(response.isOk) {
      state.isFetching.value = false;
      ReferralProgram program = ReferralProgram.fromJson(response.data);
      state.program.value = program;
    } else {
      notify.error(message: response.message);
      return;
    }
  }

  void copyLink() {
    CommonUtility.copy(state.program.value.referLink, withNotification: false);
    notify.tip(message: "Referral link copied!", color: CommonColors.hint);
  }

  String get message => "Hey there! 👋\n\n"
      "Join me and explore this amazing platform where I’ve been having a great experience.\n"
      "Sign up using my referral link to get started and enjoy exclusive benefits!\n\n"
      "${state.program.value.referLink}";
}