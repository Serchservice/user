import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActivityHistoryTripView extends StatelessWidget {
  final TripResponse trip;
  const ActivityHistoryTripView({super.key, required this.trip});

  static void open(TripResponse trip) {
    Navigate.toPage(
      widget: ActivityHistoryTripView(trip: trip),
      route: "/activity/history/trip/${trip.id}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetX<ActivityHistoryTripViewController>(
      init: ActivityHistoryTripViewController(trip: trip),
      builder: (controller) {
        TripResponse selected = controller.state.trip.value;

        return MainLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ActivityHistoryTripViewHeader(controller: controller),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      MapView(origin: controller.state.trip.value.toAddress(), height: 200),
                      Container(
                        padding: EdgeInsets.all(Sizing.space(12)),
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        width: MediaQuery.sizeOf(context).width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SText(
                              text: selected.label,
                              size: Sizing.font(12),
                              color: Theme.of(context).primaryColorLight
                            ),
                            SText(
                              text: selected.mode,
                              size: Sizing.font(12),
                              color: Theme.of(context).primaryColorLight
                            ),
                          ]
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(Sizing.space(12)),
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        width: MediaQuery.sizeOf(context).width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SText(
                              text: "Trip Id",
                              size: Sizing.font(12),
                              color: Theme.of(context).primaryColorLight
                            ),
                            SText(
                              text: selected.id.replaceAll("STRIP-", "#").substring(0, 8).toUpperCase(),
                              size: Sizing.font(12),
                              color: Theme.of(context).primaryColorLight
                            ),
                          ]
                        ),
                      ),
                      if(selected.amount.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.all(Sizing.space(12)),
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          width: MediaQuery.sizeOf(context).width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SText(
                                text: 'Workmanship',
                                size: Sizing.font(14),
                                weight: FontWeight.bold,
                                color: Theme.of(context).primaryColor
                              ),
                              const SizedBox(width: 10),
                              SText(
                                text: selected.amount,
                                size: Sizing.font(14),
                                color: Theme.of(context).primaryColor
                              ),
                            ]
                          ),
                        )
                      ],
                      ActivityHistoryTripViewProblem(controller: controller),
                      if(selected.provider != null) ...[
                        const SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.all(Sizing.space(12)),
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          width: MediaQuery.sizeOf(context).width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SText(
                                text: 'Provider Profile',
                                size: Sizing.font(14),
                                weight: FontWeight.bold,
                                color: Theme.of(context).primaryColor
                              ),
                              const SizedBox(height: 10),
                              ActivityTripItemProfile(user: selected.provider!, showCall: false)
                            ]
                          ),
                        )
                      ],
                      if(selected.timelines.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: 250,
                          padding: EdgeInsets.all(Sizing.space(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SText(
                                text: 'Trip Timeline',
                                size: Sizing.font(14),
                                weight: FontWeight.bold,
                                color: Theme.of(context).primaryColor
                              ),
                              const SizedBox(height: 6),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: selected.timelines.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    TimelineResponse timeline = selected.timelines[index];
                                    bool showBottom = index != selected.timelines.length - 1;

                                    return ActivityTripItemStep(
                                      header: timeline.header,
                                      description: timeline.description,
                                      label: timeline.label,
                                      isOver: timeline.isOver,
                                      showBottom: showBottom,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                      ActivityHistoryTripViewShared(controller: controller)
                    ],
                  )
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

extension on TripResponse {
  Address toAddress() {
    return Address(
      id: id,
      latitude: latitude,
      longitude: longitude,
      place: address,
    );
  }
}