import 'package:flutter/material.dart';
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
                  ChatMoreOptionSheet.open(room: controller.state.chatRoom.value);
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
                      child: ChatMessageList(controller: controller),
                    )
                  )
                ],
                if(controller.state.emojiShowing.value) ...[
                  //
                ] else ...[
                  ChatKeyboard(controller: controller)
                ]
              ],
            ),
          ),
        );
      }
    });
  }
}