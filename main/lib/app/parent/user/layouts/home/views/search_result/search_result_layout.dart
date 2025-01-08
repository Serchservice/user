import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchResultLayout extends GetResponsiveView<SearchResultController> {
  static const String route = "/home/result";

  static void off(RequestSearch search) => Navigate.off(
    route,
    arguments: search,
    parameters: {
      "longitude": "${search.address.longitude}",
      "latitude": "${search.address.latitude}"
    }
  );

  SearchResultLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: Obx(() => SText.center(
          text: controller.state.title.value,
          size: Sizing.font(16),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        )),
        actions: [
          Obx(() {
            int selected = controller.state.filter.value;

            return IconButton(
              onPressed: () => SearchResultFilterSheet.open(
                list: controller.filters,
                selected: selected,
                onUpdate: controller.updateSearch,
                radius: controller.state.searchRadius.value
              ),
              icon: Icon(
                Icons.filter_list_rounded,
                color: Theme.of(context).primaryColor
              )
            );
          })
        ]
      ),
      child: Obx(() {
        String message = controller.noResult();

        if(controller.state.search.value.isSearch || controller.isRequest) {
          return _buildSearch(context, message);
        } else {
          return _buildDrive(context, message);
        }
      }),
    );
  }

  Widget _buildDrive(BuildContext context, String message) {
    return PullToRefresh(
      onRefreshed: controller.shopController.refresh,
      child: PagedListView<int, SearchShopResponse>(
        pagingController: controller.shopController,
        builderDelegate: PagedChildBuilderDelegate<SearchShopResponse>(
          itemBuilder: (context, trip, index) {
            return SearchResultItem(controller: controller, shop: trip,);
          },
          firstPageErrorIndicatorBuilder: (context) => PagingFirstPageErrorIndicator(
            error: controller.shopController.error,
            onTryAgain: () => controller.shopController.refresh()
          ),
          firstPageProgressIndicatorBuilder: (_) => PagingFirstPageLoadingIndicator(height: 90,),
          noItemsFoundIndicatorBuilder: (context) => PagingNoItemFoundIndicator(
            message: message,
            icon: Icons.manage_search,
          ),
          // noMoreItemsIndicatorBuilder: (_) => NoMoreItemsIndicator(),
          // newPageProgressIndicatorBuilder: (_) => NewPageProgressIndicator(),
          // newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
          //   error: controller.shopController.error,
          //   onTryAgain: () => controller.shopController.retryLastFailedRequest(),
          // ),
        ),
      ),
    );
  }

  Widget _buildSearch(BuildContext context, String message) {
    return Obx(() {
      Active? best = controller.state.best.value;

      return PullToRefresh(
        onRefreshed: controller.searchController.refresh,
        child: Column(
          spacing: 10,
          children: [
            if(best != null) ...[
              SearchResultItem(controller: controller, active: best, isBest: true),
            ],
            Expanded(
              child: PagedListView<int, SearchItem>(
                pagingController: controller.searchController,
                builderDelegate: PagedChildBuilderDelegate<SearchItem>(
                  itemBuilder: (context, item, index) {
                    return SearchResultItem(controller: controller, shop: item.shop, active: item.active);
                  },
                  firstPageErrorIndicatorBuilder: (context) => PagingFirstPageErrorIndicator(
                    error: controller.searchController.error,
                    onTryAgain: () => controller.searchController.refresh()
                  ),
                  firstPageProgressIndicatorBuilder: (_) => PagingFirstPageLoadingIndicator(height: 90,),
                  noItemsFoundIndicatorBuilder: (context) => PagingNoItemFoundIndicator(
                    message: message,
                    icon: Icons.manage_search,
                  ),
                  // noMoreItemsIndicatorBuilder: (_) => NoMoreItemsIndicator(),
                  // newPageProgressIndicatorBuilder: (_) => NewPageProgressIndicator(),
                  // newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
                  //   error: controller.searchController.error,
                  //   onTryAgain: () => controller.searchController.retryLastFailedRequest(),
                  // ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}