import 'package:user/library.dart';

/// Abstract class to define the base structure for a service that handles
/// authentication validation and account fetching.
abstract class AuthValidatorService {
  /// Validates the existing session.
  ///
  /// @param onSuccess The callback function to be called with a success message upon successful session validation.
  /// @param onError The callback function to be called with an error message if the session validation fails.
  void validateSession({
    required Function(String success) onSuccess,
    required Function(String error) onError
  });

  /// Fetches accounts.
  ///
  /// @param onSuccess The optional callback function to be called with a list of accounts upon successful fetch.
  /// @param onError The optional callback function to be called with an error message if the account fetch fails.
  void fetchAccounts({
    Function(List<Account> success)? onSuccess,
    Function(String error)? onError
  });
}
