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
    "name": "string",
    "avatar": "string",
    "role": "string",
    "data": {
      "referralCode": "string",
      "referLink": "string",
      "credits": 0.0,
      "description": "string",
      "credit": 0,
      "reward": "REFER_TIERED"
    }
  }).obs;
}