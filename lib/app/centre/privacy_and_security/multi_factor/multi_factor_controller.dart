import 'package:get/get.dart';
import 'package:user/library.dart';

class MultiFactorController extends GetxController {
  MultiFactorController();
  final state = MultiFactorState();

  final ConnectService _connect = Connect();

  @override
  void onInit() {
    if(state.hasAuth.value) {
      fetchUsage();
      fetchCodes();
    }
    super.onInit();
  }

  void init({required Function(EnableMfaResponse) onSuccess}) async {
    state.isFetching.value = true;
    var response = await _connect.get(endpoint: "/auth/mfa/init");
    state.isFetching.value = false;
    if(response.isOk) {
      EnableMfaResponse mfa = EnableMfaResponse.fromJson(response.data);
      onSuccess.call(mfa);
    } else {
      notify.error(message: response.message);
    }
  }

  void fetchUsage() async {
    state.isFetchingUsage.value = true;
    var response = await _connect.get(endpoint: "/auth/mfa/usage");
    state.isFetchingUsage.value = false;
    if(response.isOk) {
      MfaUsageResponse mfa = MfaUsageResponse.fromJson(response.data);
      state.usage.value = mfa;
    } else {
      notify.error(message: response.message);
    }
  }

  void fetchCodes() async {
    state.isFetchingCodes.value = true;
    var response = await _connect.get(endpoint: "/auth/mfa/recovery/codes");
    state.isFetchingCodes.value = false;
    if(response.isOk) {
      List<dynamic> result = response.data;
      List<MfaRecoveryCodeResponse> codes = result.map((e) => MfaRecoveryCodeResponse.fromJson(e)).toList();
      state.codes.value = codes;
    } else {
      notify.error(message: response.message);
    }
  }
}