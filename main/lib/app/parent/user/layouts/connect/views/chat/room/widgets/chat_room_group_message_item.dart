import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ChatRoomGroupMessageItem extends StatelessWidget {
  final ChatGroupMessage group;
  final ChatRoomController controller;

  const ChatRoomGroupMessageItem({super.key, required this.group, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                child: SText(
                  text: group.label,
                  size: Sizing.font(11),
                  weight: FontWeight.bold,
                  color: Theme.of(context).primaryColorLight
                ),
              ),
            ),
          ),
        ),
        ListView.builder(
          itemCount: group.messages.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            ChatMessage message = group.messages[index];
            controller.markRead(message);

            return Container(
              margin: controller.shouldNip(index, group.messages) ? const EdgeInsets.only(top: 15) : null,
              padding: const EdgeInsets.only(bottom: 3),
              child: Obx(() {
                bool isSelected = controller.state.messageIndex.value == index
                    || controller.state.openMessage.value.id == message.id
                    || controller.state.selectedMessageId.value == message.id;

                return Material(
                  color: isSelected ? Theme.of(context).appBarTheme.backgroundColor : Colors.transparent,
                  child: InkWell(
                    onLongPress: () => controller.selectMessage(message),
                    onTap: () => controller.unselectMessage(message),
                    child: Swiper(
                      iconColor: Theme.of(context).scaffoldBackgroundColor,
                      // onLeftSwipe: (details) => controller.onMyMessageSwipe(message),
                      // onRightSwipe: (details) => controller.onOtherMessageSwipe(message),
                      child: SizedBox(
                        width: Get.width,
                        child: ChatRoomMessageCard(
                          message: message,
                          haveNip: controller.shouldNip(index, group.messages),
                          onReplyTapped: controller.scrollToMessage,
                          onMessageTapped: (message) => {},
                        ),
                      )
                    ),
                  ),
                );
              })
            );
          },
        )
      ],
    );
  }
}