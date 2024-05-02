import 'package:get/get.dart';
import 'package:user/library.dart';

class ReferralLinkVerifierController extends GetxController {
  ReferralLinkVerifierController();
  final state = ReferralLinkVerifierState();

  final Connect _connect = Connect();
  final CommonApiService _apiService = CommonApi();

  @override
  void onInit() {
    String route = Get.currentRoute;

    if(route.isEmpty) {
      SnackBars.top(message: "Referral link is not properly formatted", type: Snackbar.error);
      Navigate.all(OnboardingLayout.route);
    } else if(Database.isLoggedIn) {
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
    String link = "https://www.serchservice.com/$route";
    try {
      var res = await _connect.get(endpoint: "/referral/program/verify/link?link=$link");
      ApiResponse response = ApiResponse.fromJson(res.data);
      if(response.isOk) {
        state.message.value = "";
        state.showLoading.value = false;

        ReferralProgram program = ReferralProgram.fromJson(response.data);
        Navigate.bottomSheet(
          sheet: ReferralProgramSheet(
            program: program,
            onContinue: () => Navigate.to(EmailCheckerLayout.route, parameters: {
              "referral": program.data.referralCode,
            })
          ),
          route: "/referral/program/${program.data.referralCode}"
        );
      } else {
        SnackBars.top(message: response.message, type: Snackbar.error);
        Navigate.all(LocationCheckerLayout.route);
        return;
      }
    } on Exception catch (e) {
      Connect.showError(e);
    }
  }
}