import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class WalletState {
  /// Check if data is being fetched
  RxBool isFetching = RxBool(true);

  // Fetching wallet details
  RxBool isFetchingWallet = RxBool(true);

  /// The wallet data
  Rx<Wallet> wallet = Wallet.empty().obs;

  /// Recent transactions
  RxList<TransactionGroup> recents = <TransactionGroup>[].obs;

  /// Transaction history
  RxList<TransactionGroup> transactions = <TransactionGroup>[].obs;

  /// Is funding wallet data
  RxBool isFunding = RxBool(false);

  /// Is verifying fund action
  RxBool isVerifying = RxBool(false);

  /// Is withdrawing
  RxBool isWithdrawing = RxBool(false);

  /// Should show withdraw button
  RxBool showWithdrawButton = RxBool(false);

  /// Should show fund button
  RxBool showFundButton = RxBool(false);

  /// Payment
  Rx<Payment> payment = Payment.empty().obs;

  /// Withdrawal amount
  RxString withdrawalAmount = RxString("0");

  /// Funding amount
  RxString fundingAmount = RxString("0");
}