import 'package:stomp_dart_client/stomp_dart_client.dart';

/// Abstract class to define the base structure for a WebSocket service using the STOMP protocol.
abstract class SocketService {

  /// The WebSocket [StompClient]
  late StompClient stompClient;

  /// Initializes the WebSocket connection and sets up the subscription.
  ///
  /// @param endpoint The WebSocket endpoint to connect to. Defaults to "/ws:serch".
  /// @param callback The callback function to handle messages received from the server.
  /// @param subscribeDestination The destination to subscribe to for receiving messages.
  void initialize({
    String endpoint = "/ws:serch",
    required void Function(StompFrame) callback,
    required String subscribeDestination,
  });

  /// Handles the connection event and sets up the subscription.
  ///
  /// @param frame The STOMP frame received upon connection.
  /// @param callback The callback function to handle messages received from the server.
  /// @param subscribeDestination The destination to subscribe to for receiving messages.
  void onConnect({
    required StompFrame frame,
    required void Function(StompFrame) callback,
    required String subscribeDestination
  });

  /// Sends a message to the specified destination.
  ///
  /// @param destination The destination to send the message to.
  /// @param message Optional message headers to be sent with the message.
  /// @param data The message body to be sent. Defaults to an empty string.
  void send({
    required String destination,
    Map<String, dynamic>? message,
    String data = ""
  });

  /// Disconnects the WebSocket connection.
  void disconnect();
}