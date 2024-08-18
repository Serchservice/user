import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ChatMessageList extends StatelessWidget {
  final ChatController controller;
  const ChatMessageList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<ChatGroupMessage> groups = controller.state.chatRoom.value.groups;

      return ListView.builder(
        itemCount: groups.length,
        shrinkWrap: true,
        controller: controller.messageScrollController,
        padding: const EdgeInsets.only(bottom: 10),
        itemBuilder: (context, index) {
          ChatGroupMessage group = groups[index];

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
              _buildMessages(group)
            ],
          );
        }
      );
    });
  }

  ListView _buildMessages(ChatGroupMessage group) {
    return ListView.builder(
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
            bool isSelected = controller.state.messageIndex.value == index || controller.state.openMessage.value.id == message.id
                || controller.state.selectedMessageId.value == message.id;

            return Material(
              color: isSelected ? Theme.of(context).appBarTheme.backgroundColor : Colors.transparent,
              child: InkWell(
                onLongPress: () => controller.selectMessage(message),
                onTap: () => controller.unselectMessage(message),
                child: Swiper(
                  iconColor: Theme.of(context).scaffoldBackgroundColor,
                  onLeftSwipe: (details) => controller.onMyMessageSwipe(message),
                  onRightSwipe: (details) => controller.onOtherMessageSwipe(message),
                  child: SizedBox(
                    width: Get.width,
                    child: MessageCard(
                      message: message,
                      controller: controller,
                      haveNip: controller.shouldNip(index, group.messages),
                      goToReplied: controller.scrollToMessage
                    ),
                  )
                ),
              ),
            );
          })
        );
      },
    );
  }
}
