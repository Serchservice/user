import 'dart:async';

import 'package:user/library.dart';

class ChatRoomMessageCardController {
  ChatRoomMessageCardController();

  final EndToEndEncryptionService _e2eeService = EndToEndEncryption();

  ChatMessage? _message;
  ChatMessage get message => _message ?? ChatMessage.empty();

  final StreamController<ChatMessage> _messageController = StreamController.broadcast();
  Stream<ChatMessage> get messageStream => _messageController.stream;

  void init(ChatMessage message) {
    ChatMessage update = _updateMessageInformation(message);
    _message = update;
    Future.microtask(() => _messageController.add(update));
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

  void updateMessage(ChatMessage message) {
    ChatMessage update = _updateMessageInformation(message);
    _message = update;
    _messageController.add(update);
  }

  void dispose() {
    _messageController.close();
  }

  ChatReply messageToReply() {
    ChatReply reply = ChatReply.sending(
      message: message.message,
      type: message.type,
      sentByUser: message.isSentByCurrentUser,
      fileSize: message.fileSize,
      name: message.name
    );
    reply.copyWith(id: message.id);

    return reply;
  }
}