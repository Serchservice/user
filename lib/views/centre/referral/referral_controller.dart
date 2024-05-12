import 'package:get/get.dart';
import 'package:user/library.dart';

class ReferralController extends GetxController {
  ReferralController();
  final state = ReferralState();

  final Connect _connect = Connect();

  @override
  void onInit() {
    fetchReferrals();
    fetchProgram();
    super.onInit();
  }

  void fetchReferrals() async {
    state.isFetching.value = true;
    try {
      var res = await _connect.get(endpoint: "/referral/all");
      ApiResponse response = ApiResponse.fromJson(res.data);
      state.isFetching.value = false;
      if(response.isOk) {
        List<dynamic> result = response.data;
        List<Referral> referrals = result.map((e) => Referral.fromJson(e)).toList();
        state.referrals.value = referrals;
      } else {
        SnackBars.top(message: response.message, type: Snackbar.error);
      }
    } on Exception catch (e) {
      Connect.showError(e);
    }
  }

  void fetchProgram() async {
    state.isFetchingProgram.value = true;
    try {
      var res = await _connect.get(endpoint: "/referral/program");
      ApiResponse response = ApiResponse.fromJson(res.data);
      if(response.isOk) {
        state.isFetchingProgram.value = false;
        ReferralProgram program = ReferralProgram.fromJson(response.data);
        state.program.value = program;
      } else {
        SnackBars.top(message: response.message, type: Snackbar.error);
        return;
      }
    } on Exception catch (e) {
      Connect.showError(e);
    }
  }
}