import 'package:user/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ActivityActiveTripViewState {
  /// Trip
  Rx<TripResponse> trip = TripResponse.empty().obs;

  /// Is verifying identity
  RxBool isVerifying = RxBool(false);

  /// Auth token
  RxString authToken = RxString("");

  /// Is granting access
  RxBool isGrantingAccess = RxBool(false);

  /// Is denying access
  RxBool isDenyingAccess = RxBool(false);

  /// Is ending trip
  RxBool isEnding = RxBool(false);

  /// Checks if the details panel is minimized
  RxBool isMinimized = RxBool(true);

  /// Checks if the shared provider is on the way
  RxBool isSharedOnTheWay = RxBool(false);

  /// Checks if the provider is on the way
  RxBool isProviderOnTheWay = RxBool(false);
}