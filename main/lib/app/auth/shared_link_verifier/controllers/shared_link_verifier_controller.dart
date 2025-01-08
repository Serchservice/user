import 'package:get/get.dart';
import 'package:user/library.dart';

class SharedLinkVerifierController extends GetxController {
  SharedLinkVerifierController();
  final state = SharedLinkVerifierState();

  final ConnectService _connect = Connect(useToken: false);
  final AuthValidatorService _apiService = AuthValidator();

  List<ButtonView> buttons = [
    ButtonView(header: "Login as guest", index: 0),
    ButtonView(header: "Create a guest account", index: 1),
  ];

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
          Navigate.all(ParentLayout.route);
        },
        onError: (error) {
          EmailCheckerLayout.all();
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
            Navigate.all(ParentLayout.route);
          },
          onError: (error) {
            state.showLoading.value = false;
            EmailCheckerLayout.all();
            notify.error(message: error);
          }
        );
      } else if(Database.isGuestActive) {
        Navigate.all(GuestParentLayout.route);
      } else {
        state.showLoading.value = false;
        EmailCheckerLayout.all();
        return;
      }
    }
  }
}