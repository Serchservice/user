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
  RxList<TransactionGroup> recentList = <TransactionGroup>[].obs;

  /// Funding reference
  RxString reference = RxString("");
}