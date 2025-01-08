import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ChatRoomMessageToReply extends StatefulWidget {
  final ChatReply reply;
  final VoidCallback? onCancelled;

  const ChatRoomMessageToReply({super.key, required this.reply, this.onCancelled});

  @override
  State<ChatRoomMessageToReply> createState() => _ChatRoomMessageToReplyState();
}

class _ChatRoomMessageToReplyState extends State<ChatRoomMessageToReply> {
  final ChatRoomMessageToReplyController _controller = ChatRoomMessageToReplyController();

  @override
  void initState() {
    _controller.init(widget.reply);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ChatRoomMessageToReply oldWidget) {
    if (oldWidget.reply != widget.reply) {
      _controller.init(widget.reply);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChatReply>(
      stream: _controller.replyStream,
      builder: (_, snapshot) {
        if(snapshot.hasData && snapshot.data != null) {
          ChatReply reply = snapshot.data!;

          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: EdgeInsets.all(Sizing.space(4)),
              margin: EdgeInsets.symmetric(vertical: 5),
              width: Get.width,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: reply.color, width: 6),
                  top: BorderSide.none,
                  right: BorderSide.none,
                  bottom: BorderSide.none,
                ),
                color: Theme.of(context).appBarTheme.backgroundColor
              ),
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SText(
                          text: reply.sender,
                          size: Sizing.font(12),
                          color: Theme.of(context).primaryColor,
                          flow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => widget.onCancelled?.call(),
                        child: Icon(Icons.close, size: Sizing.font(16), color: CommonColors.darkTheme2)
                      )
                    ],
                  ),
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
                  // Message
                ]
              ),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}