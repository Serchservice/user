import 'package:get/get_rx/src/rx_types/rx_types.dart';

class EmailSwitchState {
  RxString emailAddress = RxString("");

  RxString referral = RxString("");

  RxBool isVerifying = RxBool(false);

  RxBool isVisible = RxBool(false);
}