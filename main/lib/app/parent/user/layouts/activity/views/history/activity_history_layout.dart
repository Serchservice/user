import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ActivityHistoryLayout extends GetResponsiveView<ActivityHistoryController> {
  ActivityHistoryLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isTrip = controller.state.filterIndex.value == 0;

      return PullToRefresh(
        onRefreshed: isTrip ? controller.tripController.refresh : controller.scheduleController.refresh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(Database.isUserActive) ...[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child:  Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SearchFilter(
                      list: ActivityController.data.sections,
                      selectedIndex: controller.state.filterIndex.value,
                      onSelect: (view) => controller.filter(view.index),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        if(controller.state.filterIndex.value == 0) {
                          ActivityHistoryTripFilterSheet.open(controller: controller);
                        } else {
                          ActivityHistoryScheduleFilterSheet.open(controller: controller);
                        }
                      },
                      tooltip: "More filter options",
                      icon: Icon(Icons.filter_list, color: Get.theme.primaryColor),
                    )
                  ],
                ),
              )
            ],
            Expanded(child: _buildList(context))
          ]
        ),
      );
    });
  }

  Widget _buildList(BuildContext context) {
    return Obx(() {
      if(controller.state.filterIndex.value == 0) {
        return PagedListView<int, TripResponse>(
          pagingController: controller.tripController,
          builderDelegate: PagedChildBuilderDelegate<TripResponse>(
            itemBuilder: (context, trip, index) {
              return ActivityTripItem(trip: trip, onTap: ActivityHistoryTripView.open, showStatus: false, showTimeline: true);
            },
            firstPageErrorIndicatorBuilder: (context) => PagingFirstPageErrorIndicator(
              error: controller.tripController.error,
              onTryAgain: () => controller.tripController.refresh()
            ),
            firstPageProgressIndicatorBuilder: (_) => PagingFirstPageLoadingIndicator(
              height: 70,
              padding: const EdgeInsets.all(12.0),
            ),
            noItemsFoundIndicatorBuilder: (context) => PagingNoItemFoundIndicator(
              message: "No trips",
              icon: Icons.inbox_rounded,
            ),
            // noMoreItemsIndicatorBuilder: (_) => NoMoreItemsIndicator(),
            // newPageProgressIndicatorBuilder: (_) => NewPageProgressIndicator(),
            // newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
            //   error: controller.tripController.error,
            //   onTryAgain: () => controller.tripController.retryLastFailedRequest(),
            // ),
          ),
        );
      } else {
        return PagedListView<int, ScheduleGroup>(
          pagingController: controller.scheduleController,
          builderDelegate: PagedChildBuilderDelegate<ScheduleGroup>(
            itemBuilder: (context, group, index) => ActivityScheduleGroupItem(group: group),
            firstPageErrorIndicatorBuilder: (context) => PagingFirstPageErrorIndicator(
              error: controller.scheduleController.error,
              onTryAgain: () => controller.scheduleController.refresh()
            ),
            firstPageProgressIndicatorBuilder: (_) => PagingFirstPageLoadingIndicator(
              padding: const EdgeInsets.all(12.0),
              height: 70,
            ),
            noItemsFoundIndicatorBuilder: (context) => PagingNoItemFoundIndicator(
              message: "No schedules",
              icon: Icons.schedule_outlined,
            ),
            // noMoreItemsIndicatorBuilder: (_) => NoMoreItemsIndicator(),
            // newPageProgressIndicatorBuilder: (_) => NewPageProgressIndicator(),
            // newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
            //   error: controller.scheduleController.error,
            //   onTryAgain: () => controller.scheduleController.retryLastFailedRequest(),
            // ),
          ),
        );
      }
    });
  }
}