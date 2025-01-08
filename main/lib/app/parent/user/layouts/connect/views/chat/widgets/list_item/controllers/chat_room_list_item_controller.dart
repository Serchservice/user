import 'dart:async';

import 'package:user/library.dart';

class ChatRoomListItemController {
  ChatRoom? _room;
  ChatRoom get room => _room ?? ChatRoom.empty();

  final Socket _socket = Socket();
  final EndToEndEncryptionService _e2eeService = EndToEndEncryption();
  final ChatRoomTypingController typingController = ChatRoomTypingController();

  final StreamController<ChatRoom> _roomController = StreamController.broadcast();
  Stream<ChatRoom> get activity => _roomController.stream;

  void init(ChatRoom room) {
    ChatRoom update = _updateRoomInformation(room);
    _room = update;

    Logger.log(update.room);

    typingController.init(
      update.room,
      message: update.message,
      isSending: update.isSending,
      isRead: update.isRead,
      showIcon: true
    );
    Future.microtask(() => _roomController.add(update));

    HomeController.data.announcePresence(room: room.room);

    _socket.initialize(
      callback: (frame) {
        Logger.log(frame.data);
        if(frame.hasData) {
          updateRoom(ChatRoom.fromJson(frame.data));
        }
      },
      endpoint: "/ws:serch",
      subscribeDestination: "/platform/${Database.auth.id}/chat/${room.room}"
    );
  }

  ChatRoom _updateRoomInformation(ChatRoom room) {
    if(room.isAsset) {
      return room;
    } else {
      String message = _e2eeService.decrypt(room.message);
      return room.copyWith(message: message);
    }
  }

  void updateRoom(ChatRoom room) {
    ChatRoom update = _updateRoomInformation(room);

    _room = update;
    typingController.update(message: update.message, isSending: update.isSending, isRead: update.isRead);
    _roomController.add(update);
  }

  void dispose() {
    _roomController.close();
  }
}