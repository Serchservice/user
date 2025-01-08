import 'dart:async';

import 'package:user/library.dart';

class ChatRoomMessageToReplyController {
  ChatRoomMessageToReplyController();

  final EndToEndEncryptionService _e2eeService = EndToEndEncryption();

  ChatReply? _reply;
  ChatReply get reply => _reply ?? ChatReply.empty();

  final StreamController<ChatReply> _replyController = StreamController.broadcast();
  Stream<ChatReply> get replyStream => _replyController.stream;

  void init(ChatReply reply) {
    ChatReply update = _updateReplyInformation(reply);
    _reply = update;
    Future.microtask(() => _replyController.add(update));
  }

  ChatReply _updateReplyInformation(ChatReply reply) {
    String replyData = _e2eeService.decrypt(reply.message);

    return reply.copyWith(message: replyData);
  }

  void dispose() {
    _replyController.close();
  }
}