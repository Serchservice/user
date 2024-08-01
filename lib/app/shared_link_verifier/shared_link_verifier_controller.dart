import 'package:get/get.dart';
import 'package:user/library.dart';

class SharedLinkVerifierController extends GetxController {
  SharedLinkVerifierController();
  final state = SharedLinkVerifierState();

  final ConnectService _connect = Connect(useToken: false);
  final AuthValidatorService _apiService = AuthValidator();

  @override
  void onInit() {
    String route = Get.currentRoute;

    if(route.isEmpty) {
      notify.error(message: "Shared link is not properly formatted");
      Navigate.all(OnboardingLayout.route);
    } else if(Database.isLoggedIn && route.isEmpty) {
      notify.info(message: "There is an existing account on this device.");
      state.message.value = "Logging in...";

      _apiService.validateSession(
        onSuccess: (success) {
          Navigate.all(HomeLayout.route);
        },
        onError: (error) {
          Navigate.all(EmailCheckerLayout.route);
          notify.error(message: error);
        }
      );
    } else {
      verifyLink(route);
    }

    super.onInit();
  }

  void verifyLink(String route) async {
    state.message.value = "Verifying link...";
    var response = await _connect.get(endpoint: "/auth/guest/link/verify?link=$route");
    if(response.isOk) {
      state.message.value = "";
      state.showLoading.value = false;
      SharedLinkData data = SharedLinkData.fromJson(response.data);
      state.data.value = data;
    } else {
      notify.error(message: response.message);
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
              notify.error(message: error);
            }
        );
      } else {
        state.showLoading.value = false;
        Navigate.all(LocationCheckerLayout.route);
        return;
      }
    }
  }
}