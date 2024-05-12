import 'package:get/get.dart';
import 'package:user/library.dart';

class SharedLinkVerifierController extends GetxController {
  SharedLinkVerifierController();
  final state = SharedLinkVerifierState();

  final Connect _connect = Connect();
  final CommonApiService _apiService = CommonApi();

  @override
  void onInit() {
    String route = Get.currentRoute;

    if(route.isEmpty) {
      SnackBars.top(message: "Referral link is not properly formatted", type: Snackbar.error);
      Navigate.all(OnboardingLayout.route);
    } else if(Database.isLoggedIn && route.isEmpty) {
      SnackBars.top(message: "There is an existing account on this device.", type: Snackbar.info);
      state.message.value = "Logging in...";

      _apiService.validateSession(
        onSuccess: (success) {
          Navigate.all(HomeLayout.route);
        },
        onError: (error) {
          Navigate.all(EmailCheckerLayout.route);
          SnackBars.top(message: error, type: Snackbar.error);
        }
      );
    } else {
      verifyLink(route);
    }

    super.onInit();
  }

  void verifyLink(String route) async {
    state.message.value = "Verifying link...";
    try {
      var res = await _connect.get(endpoint: "/auth/guest/link/verify?link=$route");
      ApiResponse response = ApiResponse.fromJson(res.data);
      if(response.isOk) {
        state.message.value = "";
        state.showLoading.value = false;
        SharedLinkData data = SharedLinkData.fromJson(response.data);
        state.data.value = data;
      } else {
        SnackBars.top(message: response.message, type: Snackbar.error);
        if(Database.isLoggedIn) {
          state.message.value = "Logging you in...";
          _apiService.validateSession(
            onSuccess: (success) {
              state.showLoading.value = false;
              Navigate.all(HomeLayout.route);
            },
            onError: (error) {
              state.showLoading.value = false;
              Navigate.all(LocationCheckerLayout.route);
              SnackBars.top(message: error, type: Snackbar.error);
            }
          );
        } else {
          state.showLoading.value = false;
          Navigate.all(LocationCheckerLayout.route);
          return;
        }
      }
    } on Exception catch (e) {
      Connect.showError(e);
    }
  }
}