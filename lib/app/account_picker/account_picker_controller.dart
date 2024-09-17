import 'package:get/get.dart';
import 'package:user/library.dart';

class AccountPickerController extends GetxController {
  Function()? onUserSuccess;
  Function(Guest guest)? onGuestSuccess;
  Function(bool)? onGuestError;
  Function(bool)? onUserError;
  bool isLogin;
  bool shouldNavigate;

  AccountPickerController({
    this.onUserError,
    this.onUserSuccess,
    this.onGuestSuccess,
    this.onGuestError,
    this.isLogin = true,
    this.shouldNavigate = true
  });

  final state = AccountPickerState();

  final AuthValidatorService _authService = AuthValidator();

  @override
  void onInit() {
    _fetchAccounts();
    super.onInit();
  }

  void _fetchAccounts() async {
    _authService.fetchAccounts(
      onSuccess: (account) {
        state.accounts.value = account;
      },
      onError: (error) {
        notify.error(message: error);
      }
    );
  }

  void _navigate(bool isUser, bool isGuest) {
    if(Get.currentRoute.endsWith(AccountPickerLayout.route)) {
      if(isUser) {
        if(Database.loginWithBiometrics) {
          Navigate.off(BiometricsAuthLayout.route, parameters: {
            "login": "false",
            "has_biometrics": "${Database.preference.hasBiometrics}"
          });
        } else if(Database.loginWithMFA) {
          Navigate.off(MfaAuthLayout.loginRoute);
        } else {
          Navigate.all(HomeLayout.route);
        }
      } else if(isGuest) {
        Navigate.all(GuestHomeLayout.route);
      } else {
        Navigate.all(EmailCheckerLayout.route);
      }
    }
  }

  void switchToUser(String id) async {
    if(Database.preference.active == id || Database.preference.active == "user") {
      state.isLoading.value = true;
      state.selected.value = id;

      _authService.validateSession(
        onSuccess: (result) {
          state.isLoading.value = false;
          state.selected.value = "";

          _navigate(true, false);
          if(isLogin) {
            onUserSuccess?.call();
          } else {
            Navigate.all(HomeLayout.route);
          }
        },
        onError: (error) {
          state.isLoading.value = false;
          state.selected.value = "";

          _navigate(false, false);
          if(isLogin) {
            onUserError?.call(false);
          } else {
            Navigate.all(EmailCheckerLayout.route);
          }
        }
      );
    } else {
      final ConnectService connect = Connect();
      state.isLoading.value = true;
      state.selected.value = id;

      var response = await connect.post(endpoint: "/switch/user", body: {
        "id": Database.guest.id,
        "device": Database.device.toJson(),
      });

      state.isLoading.value = false;
      state.selected.value = "";

      if(response.isOk) {
        AuthResponse auth = AuthResponse.fromJson(response.data);
        Database.saveAuth(auth);
        Database.savePreference(Database.preference.copyWith(active: id));

        _navigate(true, false);
        onUserSuccess?.call();
      } else {
        notify.error(message: response.message);
        onUserError?.call(response.isGuestOnTrip);
      }
    }
  }

  void switchToGuest({required String linkId, required String guestId}) async {
    if(Database.preference.active == linkId) {
      _navigate(false, true);
      onGuestSuccess?.call(Database.guest);
    } else {
      final ConnectService connect = Connect(useToken: Database.isUserActive);
      state.isLoading.value = true;
      state.selected.value = linkId;

      var response = await connect.post(endpoint: "/switch", body: {
        "id": guestId,
        "link_id": linkId
      });

      state.isLoading.value = false;
      state.selected.value = "";

      if(response.isOk) {
        Guest auth = Guest.fromJson(response.data);
        Database.saveGuest(auth);
        Database.savePreference(Database.preference.copyWith(active: linkId));

        _navigate(false, true);
        onGuestSuccess?.call(auth);
      } else {
        notify.error(message: response.message);
        onGuestError?.call(response.isGuestOnTrip);
      }
    }
  }

  bool isActive(Account account) {
    return Database.preference.active.isEmpty
        ? account.category.toLowerCase() == "user"
        : (Database.preference.active == "user" && account.category.toLowerCase() == "user")
        || (Database.preference.active == account.id || Database.preference.active == account.linkId);
  }
}