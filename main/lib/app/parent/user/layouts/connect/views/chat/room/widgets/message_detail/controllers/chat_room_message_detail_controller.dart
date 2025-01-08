import 'dart:async';

import 'package:user/library.dart';

class ChatRoomMessageDetailController {
  ChatRoomMessageDetailController();

  final EndToEndEncryptionService _e2eeService = EndToEndEncryption();

  ChatReply? _reply;
  ChatReply get reply => _reply ?? ChatReply.empty();

  final StreamController<ChatReply> _replyController = StreamController.broadcast();
  Stream<ChatReply> get replyStream => _replyController.stream;

  ChatMessage? _message;
  ChatMessage get message => _message ?? ChatMessage.empty();

  final StreamController<ChatMessage> _messageController = StreamController.broadcast();
  Stream<ChatMessage> get messageStream => _messageController.stream;

  void init(ChatReply? reply, ChatMessage message) {
    if(reply != null) {
      ChatReply update = _updateReplyInformation(reply);
      _reply = update;
      Future.microtask(() => _replyController.add(update));
    }

    ChatMessage update = _updateMessageInformation(message);
    _message = update;
    Future.microtask(() => _messageController.add(update));
  }

  ChatReply _updateReplyInformation(ChatReply reply) {
    String replyData = _e2eeService.decrypt(reply.message);

    return reply.copyWith(message: replyData);
  }

  ChatMessage _updateMessageInformation(ChatMessage message) {
    String messageData = _e2eeService.decrypt(message.message);

    ChatMessage update = message;
    update = update.copyWith(message: messageData);

    if(update.reply != null) {
      String replyData = _e2eeService.decrypt(update.reply!.message);
      update = update.copyWith(reply: update.reply!.copyWith(message: replyData));
    }

    return update;
  }

  void delete() {
    if(_message != null) {
      if(socket.isConnected) {
        Map<String, dynamic> update = {
          "room": _message!.room,
          "id": _message!.id,
          "state": "DELETED",
        };

        socket.send(destination: "/chat/update", message: update);
        Navigate.back();
      } else {
        notify.tip(message: "Network error");
      }
    }
  }

  void dispose() {
    _replyController.close();
    _messageController.close();
  }
}