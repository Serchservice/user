abstract class AccessService {
  /// Requests for all permissions
  Future<bool> requestPermissions();

  /// Checks if the location permissions were granted, else, request for them
  Future<bool> hasLocation();
}