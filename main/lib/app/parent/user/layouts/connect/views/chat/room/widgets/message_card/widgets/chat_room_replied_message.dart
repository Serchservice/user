import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ChatRoomRepliedMessage extends StatelessWidget {
  final ChatReply reply;
  final Function(ChatReply reply)? onReplyClicked;

  const ChatRoomRepliedMessage({super.key, required this.reply, this.onReplyClicked});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: InkWell(
          onTap: () => onReplyClicked?.call(reply),
          child: Container(
            padding: EdgeInsets.all(Sizing.space(4)),
            margin: EdgeInsets.symmetric(vertical: 1),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: reply.color, width: 6),
                top: BorderSide.none,
                right: BorderSide.none,
                bottom: BorderSide.none,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SText(
                        text: reply.sender,
                        size: Sizing.font(12),
                        color: Theme.of(context).primaryColor,
                        flow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SText(
                        text: reply.displayText,
                        size: Sizing.font(12),
                        color: CommonColors.hint,
                        flow: TextOverflow.ellipsis,
                        lines: 1
                      ),
                    )
                  ],
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}