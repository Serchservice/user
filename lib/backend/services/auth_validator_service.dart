import 'package:user/library.dart';

/// Abstract class to define the base structure for a service that handles
/// authentication validation and account fetching.
///
/// This class provides methods to validate user sessions and fetch user accounts.
/// It is intended to be extended by concrete implementations that provide the
/// actual logic for these operations.
abstract class AuthValidatorService {
  /// Validates the existing user session.
  ///
  /// This method checks whether the current user session is still valid.
  /// If the session is valid, it triggers the [onSuccess] callback with a success message.
  /// If the session validation fails, it triggers the [onError] callback with an error message.
  ///
  /// @param onSuccess A callback function to be called with a success message upon successful session validation.
  /// @param onError A callback function to be called with an error message if the session validation fails.
  void validateSession({
    required Function(String success) onSuccess,
    required Function(String error) onError
  });

  /// Fetches the list of user accounts.
  ///
  /// This method retrieves the user accounts associated with the current session.
  /// If the account fetch is successful, it triggers the [onSuccess] callback with the list of accounts.
  /// If the account fetch fails, it triggers the [onError] callback with an error message.
  ///
  /// @param onSuccess An optional callback function to be called with a list of accounts upon successful fetch.
  /// @param onError An optional callback function to be called with an error message if the account fetch fails.
  void fetchAccounts({
    Function(List<Account> success)? onSuccess,
    Function(String error)? onError
  });
}