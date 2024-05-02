import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class LocationCheckerController extends GetxController {
  LocationCheckerController();
  final state = LocationCheckerState();

  final Connect _connect = Connect(useToken: false);

  final CommonApiService _apiService = CommonApi();
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
        AppConfiguration.data.cameras = await availableCameras();
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
        SnackBars.top(message: error, type: Snackbar.error);
      }
    );
  }

  void verifyMyLocation() async {
    try {
      var response = await _connect.get(
        endpoint: "/company/countries/verify?"
          "country=${state.country.value}"
          "&state=${state.state.value}"
          "&city=${state.city.value}"
      );
      state.isVerifying.value = false;
      var data = ApiResponse.fromJson(response.data);
      if(data.isOk) {
        Navigate.off(OnboardingLayout.route);
      } else {
        if(Database.preference.hasRequestedCountry && Database.address.matches(state.country.value, state.state.value)) {
          state.isContinue.value = true;
          launchInMyCity("You have added your location to the waitlist.");
          return;
        } else {
          launchInMyCity(data.message);
        }
      }
    } on Exception catch (e) {
      state.isVerifying.value = false;
      state.retryValidation.value = true;
      Connect.showError(e);
    }
  }

  void requestLaunchInMyLocation() async {
    state.isLoading.value = true;
    try {
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

      var data = ApiResponse.fromJson(response.data);
      if(data.isOk) {
        Database.savePreference(Database.preference.copyWith(hasRequestedCountry: true));
        launchInMyCity(data.message);
      } else {
        Database.savePreference(Database.preference.copyWith(hasRequestedCountry: true));
        launchInMyCity(data.message);
      }
    } on Exception catch (e) {
      state.isLoading.value = false;
      Connect.showError(e);
    }
  }

  void navigate() async {
    /// TODO:: Add guest account checker
    if(Database.isLoggedIn) {
      state.isLoading.value = true;
      _apiService.validateSession(
        onSuccess: (success) {
          state.isLoading.value = false;
          Navigate.all(HomeLayout.route);
        },
        onError: (error) {
          state.isLoading.value = false;
          Navigate.all(EmailCheckerLayout.route);
          SnackBars.top(message: error, type: Snackbar.error);
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