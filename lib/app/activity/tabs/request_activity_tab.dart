import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class RequestActivityTab extends StatelessWidget {
  final HomeController controller;
  const RequestActivityTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Obx(() => SearchFilter(
            list: controller.activity.activities,
            selectedIndex: controller.state.requestActivityFilter.value,
            onSelect: (view) => controller.activity.filterRequest(view.index),
            more: IconButton(
              onPressed: () {
                if(controller.state.requestActivityFilter.value == 0) {
                  TripRequestedFilterSheet.open(controller: controller);
                } else {
                  ScheduleRequestedFilterSheet.open(controller: controller);
                }
              },
              tooltip: "More filter options",
              icon: Icon(
                Icons.filter_list,
                color: Theme.of(context).primaryColor,
              ),
            )
          )),
        ),
        Expanded(
          child: Obx(() {
            if (controller.state.requestActivityFilter.value == 0) {
              return _buildTrip(context);
            } else {
              return _buildSchedule(context);
            }
          }),
        )
      ],
    );
  }

  Widget _buildTrip(BuildContext context) {
    return Obx(() {
      if(controller.state.isFetchingTripInvites.value) {
        return LoadingShimmer(
          content: ListView.builder(
            itemCount: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.sizeOf(context).width,
                margin: EdgeInsets.only(bottom: Sizing.space(5)),
                padding: const EdgeInsets.all(12.0),
                height: 70,
                color: CommonColors.shimmerHigh,
              );
            }
          )
        );
      } else if(controller.state.filteredInvites.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Opacity(
                opacity: 0.5,
                child: Icon(
                  Icons.inbox_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 100
                ),
              ),
              const SizedBox(height: 6),
              SText(
                text: "No invites",
                color: Theme.of(context).primaryColorDark,
                size: Sizing.font(16)
              ),
            ],
          )
        );
      } else {
        return ListView.builder(
          itemCount: controller.state.filteredInvites.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            TripResponse trip = controller.state.filteredInvites[index];
            return TripBox(trip: trip, onTap: () => RequestedTripView.open(trip));
          },
        );
      }
    });
  }

  Widget _buildSchedule(BuildContext context) {
    return Obx(() {
      if(controller.state.isFetchingSchedules.value) {
        return LoadingShimmer(
          content: ListView.builder(
            itemCount: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.sizeOf(context).width,
                margin: EdgeInsets.only(bottom: Sizing.space(5)),
                padding: const EdgeInsets.all(12.0),
                height: 70,
                color: CommonColors.shimmerHigh,
              );
            }
          )
        );
      } else if(controller.state.filteredRequestedSchedules.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Opacity(
                opacity: 0.5,
                child: Icon(
                  Icons.schedule_outlined,
                  color: Theme.of(context).primaryColor,
                  size: 100
                ),
              ),
              const SizedBox(height: 6),
              SText(
                text: "No schedules",
                color: Theme.of(context).primaryColorDark,
                size: Sizing.font(16)
              ),
            ],
          )
        );
      } else {
        return ListView.builder(
          itemCount: controller.state.filteredRequestedSchedules.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ScheduleHistoryView(schedule: controller.state.filteredRequestedSchedules[index]);
          },
        );
      }
    });
  }
}