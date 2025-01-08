import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class BookmarkItemSheetController extends GetxController {
  final Bookmark bookmark;

  BookmarkItemSheetController({required this.bookmark});
  final state = BookmarkItemSheetState();

  final ConnectService _connect = Connect();

  void _remove () async {
    if(state.isRemoving.value) {
      return;
    } else {
      state.isRemoving.value = true;
      var response = await _connect.delete(endpoint: "/bookmark/remove?id=${bookmark.id}");

      state.isRemoving.value = false;
      if(response.isOk) {
        BookmarkController.data.bookmarkController.refresh();
        ChatRoomListController.data.roomController.refresh();
        Navigate.back();
        notify.success(message: response.message);
      } else {
        notify.error(message: response.message);
      }
    }
  }

  List<ButtonView> buttons(bool isRemoving) => [
    ButtonView(
      header: "${isRemoving ? "Removing" : "Remove"} bookmark for ${bookmark.name}",
      icon: isRemoving ? Icons.bookmark_remove_rounded : Icons.bookmark_rounded,
      color: isRemoving ? CommonColors.hint : CommonColors.yellow,
      index: 0
    ),
    if(PlatformEngine.instance.isMobile) ...[
      ButtonView(
        header: "Chat with ${bookmark.name}",
        icon: CupertinoIcons.bubble_left_bubble_right_fill,
        color: Get.theme.primaryColor,
        index: 1,
        path: ""
      ),
    ]
  ];

  void navigate(ButtonView button) {
    if(button.index == 0) {
      _remove();
    } else if(button.index == 1) {
      ChatRoomLayout.chat(roommate: bookmark.user, removeRoute: true);
    } else {
      Navigate.to(button.path);
    }
  }
}