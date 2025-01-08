import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:user/library.dart';

class CallChannelListLayout extends GetResponsiveView<CallChannelListController> {
  CallChannelListLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return PullToRefresh(
      onRefreshed: controller.callController.refresh,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Obx(() => SearchFilter(
              isShortVersion: true,
              list: controller.filters,
              selectedIndex: controller.state.filter.value,
              onSelect: (view) => controller.filter(view.index, view.header),
            )),
          ),
          Expanded(
            child: PagedListView<int, CallResponse>(
              pagingController: controller.callController,
              builderDelegate: PagedChildBuilderDelegate<CallResponse>(
                itemBuilder: (context, call, index) => CallChannelListItem(call: call),
                firstPageErrorIndicatorBuilder: (context) => PagingFirstPageErrorIndicator(
                  error: controller.callController.error,
                  onTryAgain: () => controller.callController.refresh()
                ),
                firstPageProgressIndicatorBuilder: (_) => PagingFirstPageLoadingIndicator(
                  padding: const EdgeInsets.all(12.0),
                  height: 70,
                ),
                noItemsFoundIndicatorBuilder: (context) => PagingNoItemFoundIndicator(
                  message: "No calls",
                  customIcon:  CategoryImage(image: Media.voiceCall, width: 250),
                ),
                // noMoreItemsIndicatorBuilder: (_) => NoMoreItemsIndicator(),
                // newPageProgressIndicatorBuilder: (_) => NewPageProgressIndicator(),
                // newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
                //   error: controller.callController.error,
                //   onTryAgain: () => controller.callController.retryLastFailedRequest(),
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}