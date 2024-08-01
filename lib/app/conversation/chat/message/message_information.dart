import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user/library.dart';

class MessageInformation extends StatelessWidget {
  final ChatMessage message;
  final ChatController controller;
  const MessageInformation({super.key, required this.message, required this.controller});

  static void open({required ChatMessage message, required ChatController controller}) {
    Navigate.bottomSheet(
      sheet: MessageInformation(message: message, controller: controller),
      route: "/conversation/chat/${message.room}/message/${message.id}",
      isScrollable: true,
      safeArea: false
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      child: Column(
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
            Container(
              padding: EdgeInsets.all(Sizing.space(10)),
              width: MediaQuery.of(context).size.width,
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
                    text: message.reply!.message,
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
                    text: message.reply!.sender,
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
                    text: message.reply!.label,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    size: Sizing.font(14),
                    weight: FontWeight.bold
                  ),
                ],
              ),
            ),
            if(message.isSentByCurrentUser) ...[
              const SizedBox(height: 40),
            ]
          ],
          if(message.isSentByCurrentUser) ...[
            NavigatorButton(
              header: "Delete message",
              prefixIcon: CupertinoIcons.trash_circle,
              onPressed: () =>  controller.deleteMessage(message, context),
              iconColor: CommonColors.error,
              textColor: CommonColors.error,
              radius: 24,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            )
          ]
        ],
      )
    );
  }
}