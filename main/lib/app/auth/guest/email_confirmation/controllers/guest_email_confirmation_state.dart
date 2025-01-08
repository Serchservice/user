import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:user/library.dart';

class GuestEmailConfirmationState {
  Rx<GuestEmailVerification> data = GuestEmailVerification.empty().obs;

  RxBool isCounting = RxBool(true);

  RxBool isResending = RxBool(false);

  RxBool isVerifying = RxBool(false);

  RxString token = RxString("");

  RxInt timeout = RxInt(59);
}