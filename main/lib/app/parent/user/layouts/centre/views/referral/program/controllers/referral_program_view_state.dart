import 'package:user/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ReferralProgramViewState {
  /// Is fetching referrals
  RxBool isFetching = RxBool(true);

  /// Referral Program
  Rx<ReferralProgram> program = ReferralProgram.fromJson({
    "name": "N/A",
    "avatar": "N/A",
    "role": "N/A",
    "referralCode": "N/A",
    "referLink": "N/A",
  }).obs;
}