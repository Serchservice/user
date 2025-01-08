/// A service interface for managing Firebase Remote Config interactions.
/// This abstract class provides methods to initialize the service and fetch data
/// dynamically from Firebase Remote Config.
abstract class FirebaseRemoteConfigService {
  /// Retrieves the One signal app id from Firebase Remote Config.
  ///
  /// This method returns the ID as a `String`, which is used for onesignal authentication.
  ///
  /// Example use case:
  /// ```dart
  /// String appOpenId = remoteConfigService.getOneSignalId();
  /// ```
  String getOneSignalId();
}