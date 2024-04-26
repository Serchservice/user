abstract class RemoteMessagingService {
  Future<String> getFcmToken();
  void foregroundHandler();
  void backgroundHandler();
}