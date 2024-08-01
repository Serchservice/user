import 'package:get/get.dart';

class LocationCheckerState {
  /// Can continue with all access
  RxBool canContinue = false.obs;

  /// Country
  RxString country = "".obs;

  /// State
  RxString state = "".obs;

  /// City
  RxString city = "".obs;

  /// Is Serch launched in the country
  RxBool isCountryLaunched = false.obs;

  /// Is Serch launched in the state
  RxBool isStateLaunched = false.obs;

  /// Searching for current location
  RxBool isSearching = false.obs;

  /// Is verifying the country or state for availability
  RxBool isVerifying = false.obs;

  /// Has location permission
  RxBool hasPermission = false.obs;

  /// Is Request for my location loading
  RxBool isLoading = false.obs;

  /// Is continue with login or signup
  RxBool isContinue = false.obs;

  /// Should retry location checker
  RxBool retry = false.obs;

  /// Should retry location validation
  RxBool retryValidation = false.obs;
}