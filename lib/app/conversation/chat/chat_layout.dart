import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

/// Parameters: {"room": "room id", "roommate": "roommate id"}
///
/// Arguments: {"data": "Any extra data (Most likely used when chat is started from request page)", "room": "[ChatRoom] data"}
class ChatLayout extends GetResponsiveView<ChatController> {
  static String get route => "/conversation/chat";
  ChatLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(controller.state.isFetchingData.value) {
        return const ChatLoading();
      } else {
        return MainLayout(
          appbar: AppBar(
            titleSpacing: 3,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Avatar.small(avatar: controller.state.chatRoom.value.avatar),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SText(
                        text: controller.state.chatRoom.value.name,
                        size: Sizing.font(14),
                        weight: FontWeight.bold,
                        flow: TextOverflow.ellipsis,
                        color: Theme.of(context).primaryColor,
                      ),
                      SText(
                        text: controller.state.chatRoom.value.category,
                        size: Sizing.font(12),
                        flow: TextOverflow.ellipsis,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ]
                  )
                )
              ]
            ),
            actions: [
              IconButton(
                onPressed: () {
                  controller.removeFocus();
                  controller.schedule();
                },
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.resolveWith((states) {
                    return CommonColors.shimmerBase.withOpacity(.48);
                  }),
                  shape: WidgetStateProperty.all(const CircleBorder()),
                ),
                tooltip: "Schedule",
                icon: controller.state.chatRoom.value.isScheduled
                  ? HeartBeating(
                    child: Icon(
                      Icons.calendar_month_rounded,
                      color: CommonColors.premium,
                      size: Sizing.space(18)
                    )
                  )
                  : Icon(
                    Icons.calendar_month_outlined,
                    color: Theme.of(context).primaryColor,
                    size: Sizing.space(18)
                  )
              ),
              IconButton(
                onPressed: () {
                  controller.removeFocus();
                  controller.bookmark();
                },
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.resolveWith((states) {
                    return CommonColors.shimmerBase.withOpacity(.48);
                  }),
                  shape: WidgetStateProperty.all(const CircleBorder()),
                ),
                tooltip: "Bookmark",
                icon: controller.state.isBookmarking.value
                  ? HeartBeating(
                    child: Icon(
                      controller.state.chatRoom.value.isBookmarked
                        ? Icons.bookmark_outlined
                        : Icons.bookmark_outline_outlined,
                      color: CommonColors.hint.withOpacity(0.5),
                      size: Sizing.space(18)
                    )
                  )
                : Icon(
                  controller.state.chatRoom.value.isBookmarked
                    ? Icons.bookmark_outlined
                    : Icons.bookmark_outline_outlined,
                  color: Theme.of(context).primaryColor,
                  size: Sizing.space(18)
                )
              ),
              IconButton(
                onPressed: () {
                  controller.removeFocus();
                  ChatMoreOptionSheet.open(
                    name: controller.state.chatRoom.value.name,
                    id: controller.state.chatRoom.value.roommate,
                    avatar: controller.state.chatRoom.value.avatar
                  );
                },
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.resolveWith((states) {
                    return CommonColors.shimmerBase.withOpacity(.48);
                  }),
                  shape: WidgetStateProperty.all(const CircleBorder()),
                ),
                tooltip: "More",
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: Theme.of(context).primaryColor,
                  size: Sizing.space(18)
                )
              ),
            ],
          ),
          child: GestureDetector(
            onTap: controller.removeFocus,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(controller.state.chatRoom.value.groups.isEmpty)...[
                  Expanded(
                    child: Container()
                  )
                ] else ...[
                  Expanded(
                    child: Scrollbar(
                      thickness: 2.0,
                      child: _buildMessageGroups(),
                    )
                  )
                ],
                if(controller.state.emojiShowing.value) ...[
                  //
                ] else ...[
                  _buildKeyboard(context)
                ]
              ],
            ),
          ),
        );
      }
    });
  }

  Container _buildKeyboard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if(controller.state.isSwiped.value) ...[
            ReplyMessage(
              reply: controller.state.reply.value,
              shouldFillWidth: true,
              showCancel: true,
              onCancel: () => controller.cancelReplyMessage()
            )
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  focusNode: controller.focusNode,
                  style: TextStyle(
                    fontSize: Sizing.font(15),
                    color: Theme.of(context).primaryColor
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  controller: controller.textMessage,
                  maxLines: 5,
                  minLines: 1,
                  enabled: true,
                  textAlignVertical: TextAlignVertical.center,
                  maxLengthEnforcement: MaxLengthEnforcement.none,
                  textCapitalization: TextCapitalization.sentences,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "Got something to say?",
                    hintStyle: TextStyle(
                      fontSize: Sizing.font(14),
                      color: CommonColors.hint
                    ),
                    // prefixIcon: Padding(
                    //   padding: const EdgeInsets.all(3.0),
                    //   child: IconButton(
                    //     onPressed: () {
                    //       controller.unfocus();
                    //       controller.pickGallery(context);
                    //     },
                    //     style: ButtonStyle(
                    //       backgroundColor: WidgetStateProperty.resolveWith((states) {
                    //         return Colors.transparent;
                    //       }),
                    //       overlayColor: WidgetStateProperty.resolveWith((states) {
                    //         return CommonColors.shimmerBase.withOpacity(.48);
                    //       }),
                    //       shape: WidgetStateProperty.all(const CircleBorder()),
                    //     ),
                    //     tooltip: "Pick File",
                    //     icon: Icon(
                    //       Icons.file_open_rounded,
                    //       color: CommonColors.hint,
                    //       size: Sizing.space(18)
                    //     )
                    //   ),
                    // ),
                    border: InputBorder.none,
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        color: CommonColors.hint,
                        width: 1.5
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColorDark,
                        width: 2
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                onPressed: () => controller.send(context),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if(controller.state.showSendButton.value) {
                      return Theme.of(context).primaryColor;
                    } else {
                      return Theme.of(context).appBarTheme.backgroundColor;
                    }
                  }),
                  overlayColor: WidgetStateProperty.resolveWith((states) {
                    return CommonColors.shimmerBase.withOpacity(.48);
                  }),
                  shape: WidgetStateProperty.all(const CircleBorder()),
                ),
                tooltip: "Send",
                icon: Icon(
                  Icons.arrow_upward_rounded,
                  color: controller.state.showSendButton.value
                    ? Theme.of(context).scaffoldBackgroundColor
                    : CommonColors.hint,
                  size: Sizing.space(22)
                )
              ),
              if(controller.state.showScrollButton.value) ...[
                IconButton(
                  onPressed: controller.scrollToEnd,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      return CommonColors.darkTheme2;
                    }),
                    overlayColor: WidgetStateProperty.resolveWith((states) {
                      return CommonColors.shimmerBase.withOpacity(.48);
                    }),
                    shape: WidgetStateProperty.all(const CircleBorder()),
                  ),
                  tooltip: "Scroll down",
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: CommonColors.lightTheme,
                    size: Sizing.space(22)
                  )
                )
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageGroups() {
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
        if (!controller.messageKeys.containsKey(message.id)) {
          controller.messageKeys[message.id] = GlobalKey();
        }
        GlobalKey messageKey = controller.messageKeys[message.id]!;

        return Container(
          margin: controller.shouldNip(index, group.messages) ? const EdgeInsets.only(top: 15) : null,
          padding: const EdgeInsets.only(bottom: 3),
          child: Obx(() {
            return Material(
              color: controller.state.messageIndex.value == index
                || controller.state.selectedMessage.value == message
                ? Theme.of(context).appBarTheme.backgroundColor
                : Colors.transparent,
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
                      messageKey: messageKey,
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