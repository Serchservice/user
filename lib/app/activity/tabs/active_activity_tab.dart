import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActiveActivityTab extends StatelessWidget {
  final HomeController controller;
  const ActiveActivityTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Obx(() => SearchFilter(
            list: controller.activity.activities,
            selectedIndex: controller.state.activeActivityFilter.value,
            onSelect: (view) => controller.activity.filterActive(view.index),
            more: IconButton(
              onPressed: () {
                if(controller.state.activeActivityFilter.value == 0) {
                  TripActiveFilterSheet.open(controller: controller);
                } else {
                  ScheduleActiveFilterSheet.open(controller: controller);
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
            if(controller.state.activeActivityFilter.value == 0) {
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
      if(controller.state.isFetchingTrips.value) {
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
      } else if(controller.state.filteredActiveTrips.isEmpty) {
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
                text: "No active trips",
                color: Theme.of(context).primaryColorDark,
                size: Sizing.font(16)
              ),
            ],
          )
        );
      } else {
        return ListView.builder(
          itemCount: controller.state.filteredActiveTrips.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            TripResponse trip = controller.state.filteredActiveTrips[index];
            return TripBox(trip: trip, onTap: () => ActiveTripView.open(trip), showShare: true, showTimeline: true);
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
      } else if(controller.state.filteredActiveSchedules.isEmpty) {
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
          itemCount: controller.state.filteredActiveSchedules.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ScheduleHistoryView(schedule: controller.state.filteredActiveSchedules[index]);
          },
        );
      }
    });
  }
}