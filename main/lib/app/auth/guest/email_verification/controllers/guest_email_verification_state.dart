import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:user/library.dart';

class GuestEmailVerificationState {
  Rx<GuestEmailVerification> data = GuestEmailVerification.empty().obs;

  RxBool isVerifying = RxBool(false);
}