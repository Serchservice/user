import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:user/library.dart';

class ChatRoomTextMessage extends StatelessWidget {
  final ChatMessage message;
  final GlobalKey contentKey;
  final Function(ChatMessage message) onMessageTapped;
  final Function(ChatReply reply, ChatMessage message)? onReplyClicked;

  const ChatRoomTextMessage({
    super.key,
    required this.message,
    required this.contentKey,
    this.onReplyClicked,
    required this.onMessageTapped
  });

  @override
  Widget build(BuildContext context) {
    Color color = message.isSentByCurrentUser ? CommonColors.darkTheme : CommonColors.lightTheme;
    bool padRight = message.message.length < 10 && message.reply == null;

    return Stack(
      key: contentKey,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 14, right: padRight ? 50 : 0),
          child: Column(
            spacing: 2,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(message.reply != null) ...[
                ChatRoomRepliedMessage(
                  reply: message.reply!,
                  onReplyClicked: (reply) => onReplyClicked?.call(reply, message)
                ),
              ],
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: color,
                  onTap: () => onMessageTapped.call(message),
                  child: SelectableLinkify(
                    options: const LinkifyOptions(humanize: false),
                    text: message.message,
                    style: TextStyle(
                      color: message.isSentByCurrentUser ? CommonColors.lightTheme : CommonColors.darkTheme,
                      fontSize: Sizing.font(14),
                    ),
                    onOpen: (link) => RouteNavigator.openLink(url: link.url),
                  ),
                ),
              )
            ],
          )
        ),
        Positioned(bottom: 0, right: 0, child: message.sendingIcon)
      ],
    );
  }
}