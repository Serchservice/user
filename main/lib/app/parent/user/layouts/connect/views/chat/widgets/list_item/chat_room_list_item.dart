import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ChatRoomListItem extends StatefulWidget {
  final ChatRoom room;

  const ChatRoomListItem({super.key, required this.room});

  @override
  State<ChatRoomListItem> createState() => _ChatRoomListItemState();

  static IconData getSendingIcon(bool isSending, bool isRead) {
    // room.isSending ? Icons.timelapse : room.isRead ? Icons.done_all_rounded : Icons.done_rounded
    return isSending
        ? CupertinoIcons.time
        : isRead
        ? CupertinoIcons.checkmark_alt_circle_fill
        : CupertinoIcons.checkmark_alt_circle;
  }
}

class _ChatRoomListItemState extends State<ChatRoomListItem> {
  final ChatRoomListItemController _controller = ChatRoomListItemController();

  @override
  void initState() {
    _controller.init(widget.room);
    setState(() {});

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ChatRoomListItem oldWidget) {
    if(oldWidget.room != widget.room) {
      _controller.updateRoom(widget.room);
      setState(() {});
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
    return StreamBuilder<ChatRoom>(
      stream: _controller.activity,
      builder: (_, snapshot) {
        if(snapshot.hasData && snapshot.data != null) {
          ChatRoom chat = snapshot.data!;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => ChatRoomLayout.chat(room: chat),
              child: Padding(
                padding: EdgeInsets.all(Sizing.space(12)),
                child: Row(
                  spacing: 6,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Avatar(avatar: chat.avatar, radius: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SText(
                                  text: chat.name,
                                  size: Sizing.font(16),
                                  color: Theme.of(context).primaryColor,
                                  flow: TextOverflow.ellipsis
                                ),
                              ),
                              SText(
                                text: chat.label,
                                size: Sizing.font(12),
                                color: Theme.of(context).primaryColor
                              ),
                            ],
                          ),
                          Row(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: StreamBuilder<Typing>(
                                  stream: _controller.typingController.state,
                                  builder: (context, snapshot) {
                                    if(snapshot.hasData) {
                                      Typing typing = snapshot.data!;

                                      if(typing.isTyping) {
                                        return SText(
                                          text: "Typing...",
                                          size: Sizing.font(12),
                                          flow: TextOverflow.ellipsis,
                                          color: CommonColors.green,
                                        );
                                      }
                                    }

                                    return _buildMessage(context, chat.message, chat.isSending, chat.isRead);
                                  },
                                )
                              ),
                              _buildCount(context, chat.count),
                            ]
                          ),
                        ],
                      )
                    ),
                  ],
                ),
              )
            )
          );
        } else if(snapshot.connectionState == ConnectionState.waiting) {
          return ChatRoomLoadingListItem();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildMessage(BuildContext context, String message, bool isSending, bool isRead) {
    return Row(
      spacing: 3,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          ChatRoomListItem.getSendingIcon(isSending, isRead),
          color: Theme.of(context).primaryColor,
          size: Sizing.font(16)
        ),
        Expanded(
          child: SText(
            text: message,
            size: Sizing.font(14),
            color: Theme.of(context).primaryColor,
            flow: TextOverflow.ellipsis
          ),
        ),
      ],
    );
  }

  Widget _buildCount(BuildContext context, int count) {
    if(count >= 1) {
      return CircleAvatar(
        radius: 11,
        backgroundColor: CommonColors.darkTheme2,
        child: Center(
          child: SText.center(
            text: count.toString(),
            color: CommonColors.lightTheme,
            size: Sizing.font(9)
          )
        ),
      );
    } else {
      return Container();
    }
  }
}