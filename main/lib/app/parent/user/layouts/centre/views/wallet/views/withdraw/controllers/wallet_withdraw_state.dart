import 'package:get/get_rx/src/rx_types/rx_types.dart';

class WalletWithdrawState {
  /// Is sending request
  RxBool isSending = RxBool(false);

  /// Should show request button
  RxBool showButton = RxBool(false);

  /// Amount
  RxString amount = RxString("0");
}