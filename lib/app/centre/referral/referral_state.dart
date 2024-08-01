import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class ReferralState {
  /// Is fetching referrals
  RxBool isFetching = RxBool(true);

  /// Is fetching program
  RxBool isFetchingProgram = RxBool(true);

  /// List of referrals
  RxList<Referral> referrals = <Referral>[].obs;

  /// Referral Program
  Rx<ReferralProgram> program = ReferralProgram.fromJson({
    "name": "N/A",
    "avatar": "N/A",
    "role": "N/A",
    "referralCode": "N/A",
    "referLink": "N/A",
  }).obs;
}