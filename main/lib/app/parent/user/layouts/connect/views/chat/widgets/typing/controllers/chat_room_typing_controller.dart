import 'dart:async';

import 'package:user/library.dart';

class ChatRoomTypingController {
  Typing? _typing;
  Typing get typing => _typing ?? Typing.empty();

  final Socket _socket = Socket();

  final StreamController<Typing> _typingController = StreamController.broadcast();
  Stream<Typing> get state => _typingController.stream;

  void init(String room, {String? message, bool? useTyping, bool? isSending, bool? isRead, bool? showIcon}) {
    Typing data = get(
      room: room,
      message: message,
      useTyping: useTyping,
      isSending: isSending,
      isRead: isRead,
      showIcon: showIcon
    );
    _typing = data;

    Future.microtask(() => _typingController.add(data));

    _socket.initialize(
      callback: (frame) {
        if(frame.hasData && frame.data is String) {
          TypingState event = (frame.data as String).toEvent();

          _typingController.add(get(state: event));
        }
      },
      endpoint: "/ws:serch",
      subscribeDestination: "/platform/${Database.auth.id}/chat/$room/typing"
    );
  }

  Typing get({String? room, String? message, bool? useTyping, bool? isSending, bool? isRead, bool? showIcon, TypingState? state}) {
    Typing response = Typing(
      room: room ?? typing.room,
      message: message ?? typing.message,
      useTyping: useTyping ?? typing.useTyping,
      isSending: isSending ?? typing.isSending,
      isRead: isRead ?? typing.isRead,
      showIcon: showIcon ?? typing.showIcon,
      state: state ?? typing.state,
    );

    return response;
  }

  void update({String? message, bool? useTyping, bool? isSending, bool? isRead, bool? showIcon}) {
    Typing data = get(
      message: message,
      useTyping: useTyping,
      isSending: isSending,
      isRead: isRead,
      showIcon: showIcon
    );
    _typing = data;

    _typingController.add(data);
  }

  void notify(String value) {
    if (value.isEmpty) {
      _notify(TypingState.notTyping);
    } else {
      _notify(TypingState.typing);
      Timer(Duration(seconds: 5), () {
        _notify(TypingState.notTyping);
      });
    }
  }

  void _notify(TypingState state) {
    if(_socket.isConnected) {
      Map<String, dynamic> message = {
        "room": typing.room,
        "state": state.value,
      };

      _socket.send(destination: "/chat/typing/notify", message: message);
    }
  }

  void close() {
    _typingController.close();
  }
}

enum TypingState {
  typing("TYPING"),
  notTyping("NOT_TYPING");

  final String value;
  const TypingState(this.value);
}


extension on String {
  TypingState toEvent() {
    switch (this) {
      case 'TYPING':
        return TypingState.typing;
      case 'NOT_TYPING':
        return TypingState.notTyping;
      default:
        return TypingState.notTyping;
    }
  }
}

class Typing {
  final String room;
  final String message;
  final bool useTyping;
  final bool isSending;
  final bool isRead;
  final bool showIcon;
  final TypingState state;

  Typing({
    required this.room,
    this.message = "",
    this.isSending = false,
    this.isRead = false,
    this.showIcon = false,
    this.useTyping = false,
    this.state = TypingState.notTyping
  });

  Typing copyWith({
    String? room,
    String? message,
    bool? useTyping,
    bool? isSending,
    bool? isRead,
    bool? showIcon,
    TypingState? state
  }) {
    return Typing(
      room: room ?? this.room,
      message: message ?? this.message,
      useTyping: useTyping ?? this.useTyping,
      showIcon: showIcon ?? this.showIcon,
      isSending: isSending ?? this.isSending,
      isRead: isRead ?? this.isRead,
      state: state ?? this.state
    );
  }

  bool get isTyping => state == TypingState.typing;

  factory Typing.empty() => Typing(room: "", message: "");
}