import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ChatRoomMessageCard extends StatefulWidget {
  final ChatMessage message;
  final Function(ChatReply reply, ChatMessage message) onReplyTapped;
  final Function(ChatMessage message) onMessageTapped;
  final bool haveNip;

  const ChatRoomMessageCard({
    super.key,
    required this.message,
    this.haveNip = true,
    required this.onReplyTapped,
    required this.onMessageTapped
  });

  @override
  State<ChatRoomMessageCard> createState() => _ChatRoomMessageCardState();
}

class _ChatRoomMessageCardState extends State<ChatRoomMessageCard> {
  final ChatRoomMessageCardController _controller = ChatRoomMessageCardController();

  final GlobalKey _contentKey = GlobalKey();
  double calculatedHeight = 50;
  double calculatedWidth = Get.width * 0.7;

  @override
  void initState() {
    _controller.init(widget.message);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ChatRoomMessageCard oldWidget) {
    if (oldWidget.message != widget.message) {
      _controller.updateMessage(widget.message);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_contentKey.currentContext != null) {
        final RenderBox renderBox = _contentKey.currentContext!.findRenderObject() as RenderBox;
        setState(() {
          calculatedHeight = renderBox.size.height;
          calculatedWidth = renderBox.size.width;
        });
      }
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChatMessage>(
      stream: _controller.messageStream,
      builder: (_, snapshot) {
        if(snapshot.hasData && snapshot.data != null) {
          ChatMessage message = snapshot.data!;

          return Bubble(
            key: ValueKey(message.id),
            color: message.isSentByCurrentUser ? CommonColors.darkTheme2 : CommonColors.lightTheme,
            margin: !message.isSentByCurrentUser && !widget.haveNip
                ? const BubbleEdges.only(left: 10)
                : message.isSentByCurrentUser && !widget.haveNip
                ? const BubbleEdges.only(right: 10)
                : !message.isSentByCurrentUser && widget.haveNip
                ? const BubbleEdges.only(left: 7)
                : const BubbleEdges.only(right: 7),
            padding: message.reply != null
                ? const BubbleEdges.all(5)
                : message.isAsset
                ? const BubbleEdges.all(4)
                : null,
            radius: const Radius.circular(10),
            alignment: message.isSentByCurrentUser
                ? Alignment.topRight
                : Alignment.topLeft,
            nip: message.isSentByCurrentUser && widget.haveNip
                ? BubbleNip.rightTop
                : !message.isSentByCurrentUser && widget.haveNip
                ? BubbleNip.leftTop
                : null,
            nipWidth: 5,
            elevation: 4,
            child: Container(
              constraints: BoxConstraints(maxWidth: calculatedWidth),
              color: Colors.transparent,
              child: ChatRoomMessageCardContent(
                message: message,
                contentKey: _contentKey,
                onReplyClicked: widget.onReplyTapped,
                onMessageTapped: widget.onMessageTapped,
              )
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}