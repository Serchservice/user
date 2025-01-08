import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_responsive.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class RatingBadTab extends GetResponsiveView<RatingBadTabController> {
  RatingBadTab({super.key});

  @override
  Widget build(BuildContext context) {
    return PullToRefresh(
      onRefreshed: controller.ratingController.refresh,
      child: PagedListView<int, Rating>(
        pagingController: controller.ratingController,
        builderDelegate: PagedChildBuilderDelegate<Rating>(
          itemBuilder: (context, rating, index) => RatingItem(review: rating),
          firstPageErrorIndicatorBuilder: (context) => PagingFirstPageErrorIndicator(
            error: controller.ratingController.error,
            onTryAgain: () => controller.ratingController.refresh()
          ),
          firstPageProgressIndicatorBuilder: (_) => PagingFirstPageLoadingIndicator(
            borderRadius: BorderRadius.circular(6),
            height: 90,
          ),
          noItemsFoundIndicatorBuilder: (context) => PagingNoItemFoundIndicator(
            message: "You have no bad reviews.",
            customIcon: Image.asset(Media.review, width: 250),
          ),
          // noMoreItemsIndicatorBuilder: (_) => NoMoreItemsIndicator(),
          // newPageProgressIndicatorBuilder: (_) => NewPageProgressIndicator(),
          // newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
          //   error: controller.ratingController.error,
          //   onTryAgain: () => controller.ratingController.retryLastFailedRequest(),
          // ),
        ),
      ),
    );
  }
}