import 'package:get/get.dart';
import 'package:user/library.dart';

class ReferralController extends GetxController {
  ReferralController();
  final state = ReferralState();

  final ConnectService _connect = Connect();

  @override
  void onInit() {
    fetchReferrals();
    fetchProgram();
    super.onInit();
  }

  void fetchReferrals() async {
    state.isFetching.value = true;
    var response = await _connect.get(endpoint: "/referral/all");
    state.isFetching.value = false;
    if(response.isOk) {
      List<dynamic> result = response.data;
      List<Referral> referrals = result.map((e) => Referral.fromJson(e)).toList();
      state.referrals.value = referrals;
    } else {
      notify.error(message: response.message);
    }
  }

  void fetchProgram() async {
    state.isFetchingProgram.value = true;
    var response = await _connect.get(endpoint: "/referral/program");
    if(response.isOk) {
      state.isFetchingProgram.value = false;
      ReferralProgram program = ReferralProgram.fromJson(response.data);
      state.program.value = program;
    } else {
      notify.error(message: response.message);
      return;
    }
  }
}