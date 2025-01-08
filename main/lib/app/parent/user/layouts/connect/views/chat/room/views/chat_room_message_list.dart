import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:user/library.dart';

class ChatRoomMessageList extends StatelessWidget {
  final ChatRoomController controller;

  const ChatRoomMessageList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    List<String> welcomeInfo = [
      "Chat is a temporary means of communicating with a provider on the platform.",
      "Bookmarking a provider makes it easier for Serch to preserve your chat data longer for the bookmark lifecycle.",
      "Chats are end-to-end encrypted, as such, your privacy is always preserved."
    ];

    return Scrollbar(
      thickness: 2,
      child: Obx(() {
        if(controller.state.error.value.isNotEmpty) {
          return PagingFirstPageErrorIndicator(
            error: controller.state.error.value,
            onTryAgain: () => controller.refreshMessages()
          );
        } else if(controller.state.chatRoom.value.groups.isEmpty) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SText.center(
                      text: "Before you start chatting...",
                      size: Sizing.font(16),
                      weight: FontWeight.bold,
                      autoSize: false,
                      color: Theme.of(context).primaryColor
                    ),
                    ...welcomeInfo.map((todo) => Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(CupertinoIcons.bubble_left_bubble_right_fill, color: Theme.of(context).primaryColor),
                        Expanded(child: SText(text: todo, autoSize: false, size: 14.5, color: Theme.of(context).primaryColor))
                      ],
                    )),
                  ],
                ),
              ),
            ),
          );
        } else {
          return SingleChildScrollView(
            reverse: true,
            controller: controller.messageScrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(controller.state.isLoadingMore.value) ...[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: CircularProgressIndicator(color: CommonColors.hint, strokeWidth: 4),
                    ),
                  )
                ],
                ...controller.state.chatRoom.value.groups.map((group) {
                  return ChatRoomGroupMessageItem(group: group, controller: controller);
                }),
                ChatRoomTyping(controller: controller.typingController),
              ]
            ),
          );
        }
      }),
    );
  }
}