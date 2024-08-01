import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class HistoryActivityTab extends StatelessWidget {
  final HomeController controller;
  const HistoryActivityTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Obx(() => SearchFilter(
            list: controller.activity.activities,
            selectedIndex: controller.state.historyActivityFilter.value,
            onSelect: (view) => controller.activity.filterHistory(view.index),
            more: IconButton(
              onPressed: () {
                if(controller.state.historyActivityFilter.value == 0) {
                  TripHistoryFilterSheet.open(controller: controller);
                } else {
                  ScheduleHistoryFilterSheet.open(controller: controller);
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
            if (controller.state.historyActivityFilter.value == 0) {
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
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: Sizing.space(5)),
                padding: const EdgeInsets.all(12.0),
                height: 70,
                color: CommonColors.shimmerHigh,
              );
            }
          )
        );
      } else if(controller.state.filteredTripHistory.isEmpty) {
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
                text: "No past trips",
                color: Theme.of(context).primaryColorDark,
                size: Sizing.font(16)
              ),
            ],
          )
        );
      } else {
        return ListView.builder(
          itemCount: controller.state.filteredTripHistory.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            TripResponse trip = controller.state.filteredTripHistory[index];

            return TripBox(
              trip: trip,
              onTap: () => TripHistoryOptions.open(trip),
              showStatus: false,
              showTimeline: true
            );
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
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: Sizing.space(5)),
                padding: const EdgeInsets.all(12.0),
                height: 70,
                color: CommonColors.shimmerHigh,
              );
            }
          )
        );
      } else if(controller.state.scheduleHistory.isEmpty || controller.state.filteredHistorySchedules.isEmpty) {
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
                text: controller.state.filteredHistorySchedules.isEmpty
                  ? "No schedules for selected filter"
                  : "No schedules",
                color: Theme.of(context).primaryColorDark,
                size: Sizing.font(16)
              ),
            ],
          )
        );
      } else {
        return ListView.builder(
          itemCount: controller.state.filteredHistorySchedules.length,
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 10),
          itemBuilder: (context, index) {
            ScheduleGroup group = controller.state.filteredHistorySchedules[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 6),
                  child: SText(
                      text: group.label,
                      size: Sizing.font(11),
                      weight: FontWeight.bold,
                      color: Theme.of(context).primaryColorLight
                  ),
                ),
                const Divider(color: CommonColors.darkTheme2),
                _buildScheduleItem(group)
              ],
            );
          }
        );
      }
    });
  }

  ListView _buildScheduleItem(ScheduleGroup group) {
    return ListView.builder(
      itemCount: group.schedules.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => ScheduleHistoryView(schedule: group.schedules[index]),
    );
  }
}