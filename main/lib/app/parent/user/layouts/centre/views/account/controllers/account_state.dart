import 'package:user/library.dart';
import 'package:get/state_manager.dart';

class AccountState {
  /// Is fetching
  RxBool isFetching = RxBool(true);

  /// First name
  Rx<Profile> profile = Profile.empty().obs;

  /// Phone number
  RxString phone = RxString("");

  /// Show account info
  RxBool showAccount = RxBool(Database.notifier.showAccount);
}