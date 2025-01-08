import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SharedLinksLayout extends GetResponsiveView<SharedLinksController> {
  static const String route = "/centre/account/shared-links";
  SharedLinksLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Shared Links",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
        actions: [
          InfoButton(onPressed: SharedLinkNotifier.open)
        ],
      ),
      child: PullToRefresh(
        onRefreshed: controller.sharedController.refresh,
        child: PagedListView<int, SharedLink>.separated(
          pagingController: controller.sharedController,
          separatorBuilder: (context, index) {
            return Divider(color: Theme.of(context).primaryColor);
          },
          builderDelegate: PagedChildBuilderDelegate<SharedLink>(
            itemBuilder: (context, link, index) => SharedLinkItem(link: link),
            firstPageErrorIndicatorBuilder: (context) => PagingFirstPageErrorIndicator(
              error: controller.sharedController.error,
              onTryAgain: () => controller.sharedController.refresh()
            ),
            firstPageProgressIndicatorBuilder: (_) => PagingFirstPageLoadingIndicator(
              padding: const EdgeInsets.all(12.0),
              height: 90,
              borderRadius: BorderRadius.circular(6)
            ),
            noItemsFoundIndicatorBuilder: (context) => PagingNoItemFoundIndicator(
              message: "You have no shared links",
              customIcon: Image.asset(Media.world, width: 200),
            ),
            // noMoreItemsIndicatorBuilder: (_) => NoMoreItemsIndicator(),
            // newPageProgressIndicatorBuilder: (_) => NewPageProgressIndicator(),
            // newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
            //   error: controller.sharedController.error,
            //   onTryAgain: () => controller.sharedController.retryLastFailedRequest(),
            // ),
          ),
        ),
      ),
    );
  }
}