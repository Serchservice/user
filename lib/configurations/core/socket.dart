import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:user/library.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

final class Socket implements SocketService {
  static final Socket instance = Socket();

  Map<String, String> _buildHeader() {
    var headers = Map.of({
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Database.session.accessToken}'
    });

    if (!kIsWeb) {
      headers.putIfAbsent("Content-Type", () => "application/json");
    }
    return headers;
  }

  @override
  late StompClient stompClient;

  @override
  void initialize({
    String endpoint = "/ws:serch",
    required void Function(StompFrame) callback,
    required String subscribeDestination,
  }) {
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: '${Keys.baseUrl}$endpoint',
        webSocketConnectHeaders: _buildHeader(),
        onConnect: (frame) => onConnect(
          callback: callback,
          subscribeDestination: subscribeDestination,
          frame: frame
        ),
        onWebSocketError: (dynamic error) { },
        onStompError: (dynamic error) { },
        onDisconnect: (frame) {
          Logger.log('Disconnected: ${frame.body}');
        },
      ),
    );
    stompClient.activate();
  }

  @override
  void onConnect({
    required StompFrame frame,
    required void Function(StompFrame) callback,
    required String subscribeDestination
  }) {
    Logger.log('Connected to WebSocket');
    if(stompClient.connected) {
      stompClient.subscribe(
        destination: subscribeDestination,
        headers: _buildHeader(),
        callback: callback,
      );
    }
  }

  @override
  void send({required String destination, Map<String, dynamic>? message, String data = ""}) {
    assert((message != null && data.isEmpty) || (message == null && data.isNotEmpty), "Message or data must be provided");
    if(stompClient.connected) {
      stompClient.send(
        destination: destination,
        body: data.isNotEmpty ? data : jsonEncode(message),
        headers: _buildHeader(),
      );
    }
  }

  @override
  void disconnect() {
    if(stompClient.connected) {
      stompClient.deactivate();
    }
  }
}