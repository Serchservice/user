import 'package:get/get.dart';
import 'package:user/library.dart';

class AccountController extends GetxController {
  AccountController();
  final state = AccountState();
  final HomeController home = HomeController.data;

  final ConnectService _connect = Connect();

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
    var response = await _connect.get(endpoint: "/profile");
    if(response.isOk) {
      state.isFetching.value = false;
      Profile profile = Profile.fromJson(response.data);
      updateProfile(profile);
    } else {
      notify.error(message: response.message);
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