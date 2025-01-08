import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:user/library.dart';

class BookmarkLayout extends GetResponsiveView<BookmarkController> {
  static const String route = "/centre/bookmark";
  BookmarkLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Bookmark",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
        actions: [
          InfoButton(onPressed: BookmarkNotifier.open)
        ],
      ),
      child: PullToRefresh(
        onRefreshed: controller.bookmarkController.refresh,
        child: PagedListView<int, Bookmark>(
          pagingController: controller.bookmarkController,
          builderDelegate: PagedChildBuilderDelegate<Bookmark>(
            itemBuilder: (context, bookmark, index) => BookmarkItem(bookmark: bookmark),
            firstPageErrorIndicatorBuilder: (context) => PagingFirstPageErrorIndicator(
              error: controller.bookmarkController.error,
              onTryAgain: () => controller.bookmarkController.refresh()
            ),
            firstPageProgressIndicatorBuilder: (_) => PagingFirstPageLoadingIndicator(
              height: 90,
              padding: const EdgeInsets.all(12.0),
            ),
            noItemsFoundIndicatorBuilder: (context) => PagingNoItemFoundIndicator(
              message: "You do not have any bookmarks",
              icon: Icons.bookmarks_rounded,
            ),
            // noMoreItemsIndicatorBuilder: (_) => NoMoreItemsIndicator(),
            // newPageProgressIndicatorBuilder: (_) => NewPageProgressIndicator(),
            // newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
            //   error: controller.bookmarkController.error,
            //   onTryAgain: () => controller.bookmarkController.retryLastFailedRequest(),
            // ),
          ),
        ),
      )
    );
  }
}