import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:user/library.dart';

class ChatRoomListLayout extends GetResponsiveView<ChatRoomListController> {
  ChatRoomListLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return PullToRefresh(
      onRefreshed: controller.roomController.refresh,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Obx(() => SearchFilter(
              isShortVersion: true,
              list: controller.filters,
              selectedIndex: controller.state.filter.value,
              onSelect: (view) => controller.filter(view.index),
            )),
          ),
          Expanded(
            child: PagedListView<int, ChatRoom>(
              pagingController: controller.roomController,
              builderDelegate: PagedChildBuilderDelegate<ChatRoom>(
                itemBuilder: (context, room, index) => ChatRoomListItem(room: room),
                firstPageErrorIndicatorBuilder: (context) => PagingFirstPageErrorIndicator(
                  error: controller.roomController.error,
                  onTryAgain: () => controller.roomController.refresh()
                ),
                firstPageProgressIndicatorBuilder: (_) => Column(
                  spacing: 10,
                  children: CommonUtility.generateList(6).map((_) => ChatRoomLoadingListItem()).toList(),
                ),
                noItemsFoundIndicatorBuilder: (context) => PagingNoItemFoundIndicator(
                  message: "No chats",
                  customIcon:  CategoryImage(image: Media.serchChat, width: 250),
                ),
                newPageProgressIndicatorBuilder: (_) => Center(),
                noMoreItemsIndicatorBuilder: (_) => Center(),
                // newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
                //   error: controller.roomController.error,
                //   onTryAgain: () => controller.roomController.retryLastFailedRequest(),
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}