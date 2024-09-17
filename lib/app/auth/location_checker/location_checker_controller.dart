import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class LocationCheckerController extends GetxController {
  LocationCheckerController();
  final state = LocationCheckerState();

  final ConnectService _connect = Connect(useToken: false);
  final LocationService _locationService = LocationImplementation();
  final FolderService _folderService = FolderImplementation();
  final AuthValidatorService authService = AuthValidator();
  final AppService _appService = AppImplementation();

  @override
  void onInit() {
    state.isSearching.value = true;
    super.onInit();
  }

  @override
  void onReady() {
    _initialize();
    super.onReady();
  }

  void _initialize() async {
    _appService.buildDeviceInformation(onSuccess: (device) {
      Database.initialize().then((v) => Database.saveDevice(device));
      requestAccess(device.sdk, onSuccess: () async {
        finishChecking();
        MainConfiguration.data.cameras.value = await availableCameras();
        await _folderService.createOrGetFolders();
      });
    });
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
    String q = "country=${state.country.value}&state=${state.state.value}&city=${state.city.value}";
    var response = await _connect.get(endpoint: "/company/countries/verify?$q");
    state.isVerifying.value = false;
    if(response.isOk) {
      state.isLoading.value = true;
      navigate();
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

  void navigate() async {
    if(Database.accounts.isNotEmpty) {
      AccountPickerLayout.open(
        shouldNavigate: true,
        isLogin: true,
        onUserSuccess: () {
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
        },
        onUserError: (guestOnTrip) {
          if(guestOnTrip) {
            notify.info(message: "You have an account that is on trip. You need to locate that account");
            return;
          }
          Navigate.all(EmailCheckerLayout.route);
        },
        onGuestSuccess: (guest) {
          Navigate.all(GuestHomeLayout.route);
        },
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

  void launchInMyCity(String place) => Navigate.bottomSheet(
    sheet: LaunchInMyCitySheet(controller: this, place: place),
    route: "/auth/country/launch"
  );
}