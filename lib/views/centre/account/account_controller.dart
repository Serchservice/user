import 'package:get/get.dart';
import 'package:user/library.dart';

class AccountController extends GetxController {
  AccountController();
  final state = AccountState();
  final HomeController home = Get.find<HomeController>();

  final Connect _connect = Connect();

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  void stopShowingAccount() {
    Database.saveNotifier(Database.notifier.copyWith(showAccount: false));
    state.showAccount.value = false;
  }

  void fetchProfile() async {
    state.isFetching.value = true;
    try {
      var res = await _connect.get(endpoint: "/profile");
      ApiResponse response = ApiResponse.fromJson(res.data);
      state.isFetching.value = false;
      if(response.isOk) {
        Profile profile = Profile.fromJson(response.data);
        updateProfile(profile);
      } else {
        SnackBars.top(message: response.message, type: Snackbar.error);
      }
    } on Exception catch (e) {
      Connect.showError(e);
    }
  }

  void updateProfile(Profile profile) {
    state.profile.value = profile;

    Country country = Database.countries.firstWhere((element) {
      return element.code.toLowerCase() == profile.phoneInfo.isoCode;
    }, orElse: () => Country.primary());
    state.phone.value = "${country.flag} ${profile.phoneInfo.phoneNumber}";
  }
}