import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:user/library.dart';

class ChatRoomImageMessage extends StatelessWidget{
  final ChatMessage message;

  const ChatRoomImageMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Animated(
      toWidget: ChatRoomViewImageMessage(
        image: message.message,
        header: "Sent by ${message.name}",
        data: "Message received on ${DateFormat('EEEE MMMM d, y').format(message.sentAt)}"
      ),
      route: "/connect/chat/${message.room}/${message.id}",
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          spacing: 5,
          children: [
            PhotoView(
              imageProvider: AssetUtility.image(message.message),
              loadingBuilder: (context, event) {
                return Center(child: Loading(color: Theme.of(context).primaryColor));
              },
              errorBuilder: (context, error, stackTrace) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.replay_outlined,
                      color: Theme.of(context).unselectedWidgetColor
                    )
                  )
                );
              },
            ),
            message.sendingIcon
          ],
        )
      ),
    );
  }
}