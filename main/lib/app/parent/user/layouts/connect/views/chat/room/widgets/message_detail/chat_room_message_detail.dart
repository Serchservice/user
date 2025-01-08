import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ChatRoomMessageDetail extends StatefulWidget {
  final ChatMessage message;
  final ChatReply? reply;

  const ChatRoomMessageDetail({super.key, required this.message, this.reply});

  static void open({required ChatMessage message, ChatReply? reply}) {
    String baseUrl = "/conversation/chat/${message.room}/${message.id}/details";
    String route = reply == null ? baseUrl : "$baseUrl/${reply.id}";

    Navigate.bottomSheet(
      sheet: ChatRoomMessageDetail(message: message, reply: reply),
      route: route,
      isScrollable: true,
      safeArea: false
    );
  }

  @override
  State<ChatRoomMessageDetail> createState() => _ChatRoomMessageDetailState();
}

class _ChatRoomMessageDetailState extends State<ChatRoomMessageDetail> {
  final ChatRoomMessageDetailController _controller = ChatRoomMessageDetailController();

  @override
  void initState() {
    _controller.init(widget.reply, widget.message);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.reply != null) {
      return CurvedBottomSheet(
        safeArea: true,
        margin: const EdgeInsets.all(16),
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(24),
        child: StreamBuilder<ChatReply>(
          stream: _controller.replyStream,
          builder: (context, snapshot) {
            if(snapshot.hasData && snapshot.data != null) {
              ChatReply reply = snapshot.data!;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReply(context, reply),
                ],
              );
            } else {
              return SizedBox.shrink();
            }
          },
        )
      );
    } else {
      return _buildMessage(context);
    }
  }

  Widget _buildMessage(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      child: StreamBuilder<ChatMessage>(
        stream: _controller.messageStream,
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data != null) {
            ChatMessage message = snapshot.data!;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(Sizing.space(2)),
                    margin: EdgeInsets.all(Sizing.space(12)),
                    alignment: Alignment.center,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(16)
                    ),
                  ),
                ),
                Center(
                  child: SText.center(
                    text: message.label,
                    size: Sizing.font(16),
                    weight: FontWeight.bold,
                    color: Theme.of(context).primaryColor
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SText(
                    text: "Message",
                    color: Theme.of(context).primaryColor,
                    size: Sizing.font(14),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SText(
                    text: message.message,
                    color: Theme.of(context).primaryColor,
                    size: Sizing.font(16),
                    weight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SText(
                    text: "Sent By",
                    color: Theme.of(context).primaryColor,
                    size: Sizing.font(14),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SText(
                    text: message.name,
                    color: Theme.of(context).primaryColor,
                    size: Sizing.font(16),
                    weight: FontWeight.bold
                  ),
                ),
                if(message.reply == null) ...[
                  if(message.isSentByCurrentUser) ...[
                    const SizedBox(height: 40),
                  ]
                ] else ...[
                  const SizedBox(height: 20),
                  _buildReply(context, message.reply!),
                  if(message.isSentByCurrentUser) ...[
                    const SizedBox(height: 40),
                  ]
                ],
                if(message.isSentByCurrentUser) ...[
                  NavigatorButton(
                    header: "Delete message",
                    prefixIcon: CupertinoIcons.trash_circle,
                    onPressed: () =>  _controller.delete(),
                    iconColor: CommonColors.error,
                    textColor: CommonColors.error,
                    radius: 24,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  )
                ]
              ],
            );
          } else {
            return SizedBox.shrink();
          }
        },
      )
    );
  }

  Widget _buildReply(BuildContext context, ChatReply reply) {
    return Container(
      padding: EdgeInsets.all(Sizing.space(10)),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(24)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SText(
            text: "Message",
            color: Theme.of(context).scaffoldBackgroundColor,
            size: Sizing.font(14),
          ),
          const SizedBox(height: 5),
          SText(
            text: reply.message,
            color: Theme.of(context).scaffoldBackgroundColor,
            size: Sizing.font(14),
            weight: FontWeight.bold
          ),
          const SizedBox(height: 10),
          SText(
            text: "Sent By",
            color: Theme.of(context).scaffoldBackgroundColor,
            size: Sizing.font(14),
          ),
          const SizedBox(height: 5),
          SText(
            text: reply.sender,
            color: Theme.of(context).scaffoldBackgroundColor,
            size: Sizing.font(14),
            weight: FontWeight.bold
          ),
          const SizedBox(height: 10),
          SText(
            text: "Message Sent Time",
            color: Theme.of(context).scaffoldBackgroundColor,
            size: Sizing.font(14),
          ),
          const SizedBox(height: 5),
          SText(
            text: reply.label,
            color: Theme.of(context).scaffoldBackgroundColor,
            size: Sizing.font(14),
            weight: FontWeight.bold
          ),
        ],
      ),
    );
  }
}