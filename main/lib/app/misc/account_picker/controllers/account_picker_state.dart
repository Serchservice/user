import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class AccountPickerState {
  /// Accounts for the user
  RxList<Account> accounts = Database.accounts.obs;

  /// Is verifying a selected account
  RxBool isLoading = RxBool(false);

  /// Selected account
  RxString selected = RxString("");
}