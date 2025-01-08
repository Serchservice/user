import 'package:user/library.dart';
import 'package:websocket_flutter/websocket_flutter.dart';
import 'package:connectify_flutter/connectify_flutter.dart' as connect;

final class Socket {
  static final Socket instance = Socket();
  WebSocketService socket = WebSocket();

  bool get isConnected => socket.isConnected;

  void initialize({String endpoint = "/ws:serch", required void Function(SocketResponse) callback, required String subscribeDestination}) {
    socket.init(config: WebSocketConfig(
      useToken: true,
      mode: Server.PRODUCTION,
      session: Database.session.toSession(),
      onReceived: callback,
      endpoint: endpoint,
      subscription: subscribeDestination,
      baseUrl: "http://192.168.43.153:8080/api/v1",
      showSendLogs: true,
      showErrorLogs: true,
      showConnectionLogs: true,
      isWebPlatform: PlatformEngine.instance.isWeb,
      onSessionUpdate: (session) => Database.saveSession(session.toSession()),
      headers: {
        'X-Serch-Signed': Keys.signature
      }
    ));
  }

  void send({required String destination, Map<String, dynamic>? message, String data = ""}) {
    socket.send(endpoint: destination, message: message, data: data);
  }

  void disconnect() {
    socket.disconnect();
  }
}

extension on connect.SessionResponse {
  SessionResponse toSession() {
    return SessionResponse(
      accessToken: accessToken,
      refreshToken: refreshToken
    );
  }
}

extension on SessionResponse {
  connect.SessionResponse toSession() {
    return connect.SessionResponse(
      accessToken: accessToken,
      refreshToken: refreshToken
    );
  }
}