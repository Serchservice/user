import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ChatRoomMessageCardContent extends StatelessWidget {
  final ChatMessage message;
  final GlobalKey contentKey;
  final Function(ChatMessage message) onMessageTapped;
  final Function(ChatReply reply, ChatMessage message)? onReplyClicked;

  const ChatRoomMessageCardContent({
    super.key,
    required this.message,
    this.onReplyClicked,
    required this.contentKey,
    required this.onMessageTapped
  });

  @override
  Widget build(BuildContext context) {
    if(message.message.isNotEmpty) {
      if(message.isAsset) {
        return Column(
          spacing: 2,
          key: contentKey,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(message.reply != null) ...[
              ChatRoomRepliedMessage(
                reply: message.reply!,
                onReplyClicked: (reply) => onReplyClicked?.call(reply, message)
              ),
            ],
            if(message.type.toLowerCase() == "image")...[
              ChatRoomImageMessage(message: message)
            ]
          ],
        );
      } else {
        return ChatRoomTextMessage(
          message: message,
          contentKey: contentKey,
          onReplyClicked: onReplyClicked,
          onMessageTapped: onMessageTapped
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }
}