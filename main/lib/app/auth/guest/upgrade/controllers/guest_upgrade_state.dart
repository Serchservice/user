import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GuestUpgradeState {
  RxString countryCode = RxString("");

  RxString isoCode = RxString("");

  RxString country = RxString("");

  RxString guestId = RxString("");

  RxString linkId = RxString("");

  RxBool isLoading = RxBool(false);

  RxBool isVisible = RxBool(false);
}