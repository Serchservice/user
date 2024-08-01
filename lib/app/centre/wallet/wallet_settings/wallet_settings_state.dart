import 'package:get/get_rx/src/rx_types/rx_types.dart';

class WalletSettingsState {
  /// Is updating wallet data
  RxBool isUpdating = RxBool(false);

  /// Should show update button
  RxBool showUpdateButton = RxBool(false);

  /// Should payout on payday
  RxBool shouldPayoutOnPayday = RxBool(false);
}