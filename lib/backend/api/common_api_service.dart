import 'package:user/library.dart';

abstract class CommonApiService {
  /// Validate existing session
  void validateSession({
    required Function(String success) onSuccess,
    required Function(String error) onError
  });

  /// Fetch accounts
  void fetchAccounts({
    Function(List<Account> success)? onSuccess,
    Function(String error)? onError
  });
}