/// Abstract service for managing local notifications for foreground operations.
abstract class NotificationService {

  /// Initializes the local notification system for foreground operations.
  void init();

  /// Initialize main isolate
  void initPort();

  /// Remove notification from notification tray
  void removeNotification(int id, {bool canDismissAll = false, String channel = "", String group = ""});
}