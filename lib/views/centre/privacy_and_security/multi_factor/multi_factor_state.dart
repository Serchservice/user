import 'package:get/get.dart';
import 'package:user/library.dart';

class MultiFactorState {
  /// Has MFA
  RxBool hasAuth = RxBool(Database.auth.hasMfa);

  /// Is Fetching MFA
  RxBool isFetching = RxBool(false);

  /// Is Fetching MFA Usage
  RxBool isFetchingUsage = RxBool(false);

  /// Is Fetching MFA Recovery Codes
  RxBool isFetchingCodes = RxBool(false);

  /// MFA Recovery Codes
  RxList<MfaRecoveryCode> codes = <MfaRecoveryCode>[].obs;

  /// MFA Data
  Rx<MfaUsage> usage = MfaUsage(total: 0, unused: 0, used: 0).obs;

  /// Is disabling
  RxBool isDisabling = RxBool(false);
}