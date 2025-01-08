import 'package:get/get.dart';
import 'package:user/library.dart';

class ReferralLinkVerifierController extends GetxController {
  ReferralLinkVerifierController();
  final state = ReferralLinkVerifierState();

  final ConnectService _connect = Connect(useToken: false);
  final AuthValidatorService _apiService = AuthValidator();

  @override
  void onInit() {
    String route = Get.currentRoute;

    if(route.isEmpty) {
      notify.error(message: "Referral link is not properly formatted");
      Navigate.all(OnboardingLayout.route);
    } else if(Database.isLoggedIn) {
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
    var response = await _connect.get(endpoint: "/referral/program/verify/link?link=$route");
    if(response.isOk) {
      state.message.value = "";
      state.showLoading.value = false;

      ReferralProgram program = ReferralProgram.fromJson(response.data);
      Navigate.bottomSheet(
        sheet: ReferralProgramSheet(
          program: program,
          onContinue: () => EmailCheckerLayout.to(referral: program.referralCode)
        ),
        safeArea: false,
        isScrollable: true,
        route: "/referral/program/${program.referralCode}"
      );
    } else if(Database.isGuestActive) {
      Navigate.all(GuestParentLayout.route);
    } else {
      notify.error(message: response.message);
      EmailCheckerLayout.all();
      return;
    }
  }
}