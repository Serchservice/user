import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ChatRoomLayout extends GetResponsiveView<ChatRoomController> {
  static String get route => "/conversation/chat";

  static void chat({String roommate = "", bool removeRoute = false, ChatRoom? room}) {
    Map<String, String> params = {"roommate": room != null ? room.roommate : roommate};

    if(room != null) {
      params.putIfAbsent("room", () => room.room);
    }
    Map<String, dynamic>? args = room != null ? {"room": room.toJson()} : null;

    if(removeRoute) {
      Navigate.offTill(ChatRoomLayout.route, ModalRoute.withName(ParentLayout.route), parameters: params);
    } else if(room != null) {
      Navigate.to(ChatRoomLayout.route, parameters: params, arguments: args);
    } else {
      Navigate.to(ChatRoomLayout.route, parameters: params);
    }
  }

  ChatRoomLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(controller.state.isFetchingData.value) {
        return const ChatRoomLoading();
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
              InfoButton(
                onPressed: controller.schedule,
                tip: "Schedule",
                icon: _buildScheduleIcon(context, controller.state.chatRoom.value)
              ),
              InfoButton(
                onPressed: controller.bookmark,
                tip: "Bookmark",
                icon: _buildBookmarkIcon(context, controller.state.chatRoom.value)
              ),
              InfoButton(onPressed: controller.openOption),
            ],
          ),
          child: GestureDetector(
            onTap: controller.removeFocus,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: ChatRoomMessageList(controller: controller)),
                _buildKeyboardView(context, controller.state.emojiShowing.value)
              ],
            ),
          ),
        );
      }
    });
  }

  Widget _buildScheduleIcon(BuildContext context, ChatRoom room) {
    IconData icon = room.isScheduled ? Icons.calendar_month_rounded : Icons.calendar_month_outlined;
    double size = Sizing.space(18);

    if(room.isScheduled) {
      return HeartBeating(child: Icon(icon, color: CommonColors.premium, size: size));
    } else {
      return Icon(icon, color: Theme.of(context).primaryColor, size: size);
    }
  }

  Widget _buildBookmarkIcon(BuildContext context, ChatRoom room) {
    IconData icon = room.isBookmarked ? Icons.bookmark_outlined : Icons.bookmark_outline_outlined;
    double size = Sizing.space(18);

    if(room.isBookmarking) {
      return HeartBeating(child: Icon(icon, color: CommonColors.hint.withValues(alpha: 0.5), size: size));
    } else {
      return Icon(icon, color: Theme.of(context).primaryColor, size: size);
    }
  }

  Widget _buildKeyboardView(BuildContext context, bool showEmoji) {
    if(showEmoji) {
      return Container();
    } else {
      return ChatRoomKeyboard(controller: controller);
    }
  }
}