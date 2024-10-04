import 'package:connectify_flutter/connectify_flutter.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:user/library.dart';

final class Socket {
  static final Socket instance = Socket();

  final SocketIt _socketIt = SocketIt(options: ConnectifyOptions(
    useToken: true,
    showLog: false,
    session: Database.session,
    mode: ConnectifyMode.PRODUCTION
  ));

  bool get isConnected => _socketIt.isConnected;

  void initialize({String endpoint = "/ws:serch", required void Function(StompFrame) callback, required String subscribeDestination}) {
    _socketIt.initialize(callback: callback, subscribeDestination: subscribeDestination);
  }

  void onConnect({required StompFrame frame, required void Function(StompFrame) callback, required String subscribeDestination}) {
    _socketIt.onConnect(frame: frame, callback: callback, subscribeDestination: subscribeDestination);
  }

  void send({required String destination, Map<String, dynamic>? message, String data = ""}) {
    _socketIt.send(destination: destination, message: message, data: data);
  }

  void disconnect() {
    _socketIt.disconnect();
  }
}