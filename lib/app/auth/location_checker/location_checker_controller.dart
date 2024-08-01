import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class LocationCheckerController extends GetxController {
  LocationCheckerController();
  final state = LocationCheckerState();

  final ConnectService _connect = Connect(useToken: false);
  final LocationService _locationService = LocationImplementation();
  final FolderService _folderService = FolderImplementation();
  final AccessService _accessService = AccessImplementation();

  @override
  void onInit() {
    state.isSearching.value = true;
    super.onInit();
  }

  @override
  void onReady() {
    requestAccess();
    super.onReady();
  }

  Future<void> requestAccess() async {
    state.canContinue.value = await _accessService.requestPermissions();
    if(state.canContinue.value) {
      if(GetPlatform.isMobile || GetPlatform.isIOS) {
        MainConfiguration.data.cameras.value = await availableCameras();
        await _folderService.createOrGetFolders().then((value) async {
          finishChecking();
        });
      }
    } else {
      requestAccess();
    }
  }

  void finishChecking() async {
    await _locationService.getAddress(
      onSuccess: (address, position) {
        state.country.value = address.country;
        state.state.value = address.state;
        state.city.value = address.city;
        state.isSearching.value = false;
        state.isVerifying.value = true;
        Database.saveAddress(address);

        verifyMyLocation();
      },
      onError: (error) {
        state.isSearching.value = false;
        state.retry.value = true;
        state.country.value = "";
        notify.error(message: error);
      }
    );
  }

  void verifyMyLocation() async {
    var response = await _connect.get(
        endpoint: "/company/countries/verify?"
            "country=${state.country.value}"
            "&state=${state.state.value}"
            "&city=${state.city.value}"
    );
    state.isVerifying.value = false;
    if(response.isOk) {
      Navigate.off(OnboardingLayout.route);
    } else {
      if(Database.preference.hasRequestedCountry && Database.address.matches(state.country.value, state.state.value)) {
        state.isContinue.value = true;
        launchInMyCity("You have added your location to the waitlist.");
        return;
      } else {
        launchInMyCity(response.message);
      }
    }
  }

  void requestLaunchInMyLocation() async {
    state.isLoading.value = true;
    var response = await _connect.post(
        endpoint: "/company/countries/request",
        body: {
          "country": state.country.value,
          "state": state.state.value,
          "city": state.city.value,
        }
    );
    state.isLoading.value = false;
    state.isContinue.value = true;
    Get.isBottomSheetOpen != null ? Get.close(1) : null;

    if(response.isOk) {
      Database.savePreference(Database.preference.copyWith(hasRequestedCountry: true));
      launchInMyCity(response.message);
    } else {
      Database.savePreference(Database.preference.copyWith(hasRequestedCountry: true));
      launchInMyCity(response.message);
    }
  }

  void navigate() async {
    if(Database.accounts.isNotEmpty) {
      AccountPicker.open(
        shouldNavigate: true,
        isLogin: true,
        onUserSuccess: () {
          if(Database.loginWithBiometrics) {
            BiometricsSheet.login();
          } else if(Database.loginWithMFA) {
            AuthWithMultiFactor.login();
          } else {
            Navigate.all(HomeLayout.route);
          }
        },
        onUserError: (guestOnTrip) {
          if(guestOnTrip) {
            notify.info(message: "You have an account that is on trip. You need to locate that account");
            return;
          }
          Navigate.all(EmailCheckerLayout.route);
        },
        onGuestSuccess: (guest) => Navigate.all(GuestHomeLayout.route),
        onGuestError: (guestOnTrip) {
          if(guestOnTrip) {
            notify.info(message: "You have a guest account that is on trip. You need to locate that account");
          }
        }
      );
    } else {
      Navigate.all(OnboardingLayout.route);
    }
  }

  void launchInMyCity(String place) => Navigate.bottomSheet(
    sheet: LaunchInMyCitySheet(controller: this, place: place),
    route: "/auth/country/launch"
  );
}