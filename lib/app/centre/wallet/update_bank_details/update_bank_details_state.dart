import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:user/library.dart';

class UpdateBankDetailsState {
  /// Is updating wallet data
  RxBool isUpdating = RxBool(false);

  /// Is fetching bank details
  RxBool isLoadingBanks = RxBool(true);

  /// Is fetching bank account details
  RxBool isFetchingBankAccount = RxBool(false);

  /// List of banks
  RxList<Bank> banks = RxList<Bank>();

  /// List of banks
  RxList<Bank> filteredBanks = RxList<Bank>();

  /// Selected bank
  Rx<Bank> bank = Bank(name: "", code: "").obs;

  /// Bank account
  Rx<BankAccount> account = BankAccount(accountNumber: "", accountName: "").obs;
}