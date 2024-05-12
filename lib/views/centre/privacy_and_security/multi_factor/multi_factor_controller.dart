import 'package:get/get.dart';
import 'package:user/library.dart';

class MultiFactorController extends GetxController {
  MultiFactorController();
  final state = MultiFactorState();

  final Connect _connect = Connect();

  @override
  void onInit() {
    if(state.hasAuth.value) {
      fetchUsage();
      fetchCodes();
    }
    super.onInit();
  }

  void init({required Function(EnableMfa) onSuccess}) async {
    state.isFetching.value = true;
    try {
      var res = await _connect.get(endpoint: "/auth/mfa/init");
      ApiResponse response = ApiResponse.fromJson(res.data);
      state.isFetching.value = false;
      if(response.isOk) {
        EnableMfa mfa = EnableMfa.fromJson(response.data);
        onSuccess.call(mfa);
      } else {
        SnackBars.top(message: response.message, type: Snackbar.error);
      }
    } on Exception catch (e) {
      state.isFetching.value = false;
      Connect.showError(e);
    }
  }

  void fetchUsage() async {
    state.isFetchingUsage.value = true;
    try {
      var res = await _connect.get(endpoint: "/auth/mfa/usage");
      ApiResponse response = ApiResponse.fromJson(res.data);
      state.isFetchingUsage.value = false;
      if(response.isOk) {
        MfaUsage mfa = MfaUsage.fromJson(response.data);
        state.usage.value = mfa;
      } else {
        SnackBars.top(message: response.message, type: Snackbar.error);
      }
    } on Exception catch (e) {
      Connect.showError(e);
    }
  }

  void fetchCodes() async {
    state.isFetchingCodes.value = true;
    try {
      var res = await _connect.get(endpoint: "/auth/mfa/recovery/codes");
      ApiResponse response = ApiResponse.fromJson(res.data);
      Logger.log(response.toJson());
      state.isFetchingCodes.value = false;
      if(response.isOk) {
        List<dynamic> result = response.data;
        List<MfaRecoveryCode> codes = result.map((e) => MfaRecoveryCode.fromJson(e)).toList();
        state.codes.value = codes;
      } else {
        SnackBars.top(message: response.message, type: Snackbar.error);
      }
    } on Exception catch (e) {
      Connect.showError(e);
    }
  }
}