abstract class CommonApiService {
  /// Validate existing session
  void validateSession({
    required Function(String success) onSuccess,
    required Function(String error) onError
  });
}