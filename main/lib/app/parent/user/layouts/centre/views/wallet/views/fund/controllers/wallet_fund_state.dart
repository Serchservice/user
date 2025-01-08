import 'package:get/get_rx/src/rx_types/rx_types.dart';

class WalletFundState {
  /// Is sending request
  RxBool isSending = RxBool(false);

  /// Is verifying request action
  RxBool isVerifying = RxBool(false);

  /// Should show request button
  RxBool showButton = RxBool(false);

  /// Amount
  RxString amount = RxString("0");
}