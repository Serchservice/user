import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ChatRoomTyping extends StatelessWidget {
  final ChatRoomTypingController controller;

  const ChatRoomTyping({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Typing>(
      stream: controller.state,
      initialData: controller.typing,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          Typing typing = snapshot.data!;

          if(typing.isTyping && typing.useTyping) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Bubble(
                color: CommonColors.lightTheme,
                margin: const BubbleEdges.only(left: 7),
                radius: const Radius.circular(10),
                padding: BubbleEdges.all(2),
                alignment: Alignment.topLeft,
                nip: BubbleNip.leftTop,
                nipWidth: 5,
                elevation: 2,
                child: LoadingShimmer(content: Icon(CupertinoIcons.ellipsis)),
              ),
            );
          } else if(typing.isTyping) {
            return SText(
              text: "Typing...",
              size: Sizing.font(12),
              flow: TextOverflow.ellipsis,
              color: CommonColors.green,
            );
          } else if(typing.showIcon && typing.message.isNotEmpty) {
            return Row(
              spacing: 3,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  ChatRoomListItem.getSendingIcon(typing.isSending, typing.isRead),
                  color: Theme.of(context).primaryColor,
                  size: Sizing.font(16)
                ),
                Expanded(
                  child: SText(
                    text: typing.message,
                    size: Sizing.font(14),
                    color: Theme.of(context).primaryColor,
                    flow: TextOverflow.ellipsis
                  ),
                ),
              ],
            );
          } else if(typing.message.isNotEmpty) {
            return SText(
              text: typing.message,
              size: Sizing.font(12),
              flow: TextOverflow.ellipsis,
              color: Theme.of(context).primaryColorLight,
            );
          } else {
            return SizedBox.shrink();
          }
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}