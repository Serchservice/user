import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GuestLoginState {
  RxBool isVerifying = RxBool(false);

  RxString link = RxString("");

  RxString linkId = RxString("");
}