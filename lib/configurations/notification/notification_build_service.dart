import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:user/library.dart';

/// Abstract service for building various types of notifications.
///
/// This service checks user preferences to determine if the notifications
/// should be in-app, phone, or both, and constructs notifications based on
/// the payload received from the server.
abstract class NotificationBuildService {

  /// Builds a call notification.
  ///
  /// Checks user [Preference] for in-app or phone or both.
  /// The data for the notification comes from the payload sent from the server.
  ///
  /// @param message The [RemoteMessage] payload data from the server.
  /// @param isBackground Indicates if the notification is being built in the background.
  void buildCall({required RemoteMessage message, bool isBackground = false});

  /// Builds a chat notification.
  ///
  /// Checks user [Preference] for in-app or phone or both.
  /// The data for the notification comes from the payload sent from the server.
  ///
  /// @param message The [RemoteMessage] payload data from the server.
  /// @param isBackground Indicates if the notification is being built in the background.
  void buildChat({required RemoteMessage message, bool isBackground = false});

  /// Builds a connect notification.
  ///
  /// Checks user [Preference] for in-app or phone or both.
  /// The data for the notification comes from the payload sent from the server.
  ///
  /// @param message The [RemoteMessage] payload data from the server.
  /// @param isBackground Indicates if the notification is being built in the background.
  void buildConnect({required RemoteMessage message, bool isBackground = false});

  /// Builds a schedule notification.
  ///
  /// Checks user [Preference] for in-app or phone or both.
  /// The data for the notification comes from the payload sent from the server.
  ///
  /// @param message The [RemoteMessage] payload data from the server.
  /// @param isBackground Indicates if the notification is being built in the background.
  void buildSchedule({required RemoteMessage message, bool isBackground = false});

  /// Builds a request notification.
  ///
  /// Checks user [Preference] for in-app or phone or both.
  /// The data for the notification comes from the payload sent from the server.
  ///
  /// @param message The [RemoteMessage] payload data from the server.
  /// @param isBackground Indicates if the notification is being built in the background.
  void buildRequest({required RemoteMessage message, bool isBackground = false});

  /// Builds a generic notification.
  ///
  /// Constructs the notification data based on the payload received.
  ///
  /// @param message The [RemoteMessage] payload message from the server.
  /// @param isBackground Indicates if the notification is being built in the background.
  /// @param shouldNavigate Indicates if the notification should navigate to a specific screen.
  void build({required RemoteMessage message, bool isBackground = false, bool shouldNavigate = false});

  /// Builds a call tracker.
  ///
  /// Constructs the call tracker data based on the active call response.
  ///
  /// @param call The [ActiveCallResponse] containing the call data.
  void buildCallTracker(ActiveCallResponse call);

  /// Updates the call tracker.
  ///
  /// Updates the call tracker data based on the active call response.
  ///
  /// @param call The [ActiveCallResponse] containing the updated call data.
  void updateCallTracker(ActiveCallResponse call);

  /// Ends the call tracker.
  ///
  /// Ends the call tracker based on the active call response.
  ///
  /// @param call The [ActiveCallResponse] containing the call data to end the tracker.
  void endCallTracker(ActiveCallResponse call);
}