import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActivityRequestedTripView extends StatelessWidget {
  final TripResponse trip;
  const ActivityRequestedTripView({super.key, required this.trip});

  static void open(TripResponse trip) {
    String route = "/activity/requested/trip/${trip.id}";

    Navigate.toPage(
      widget: ActivityRequestedTripView(trip: trip),
      route: Database.isUserActive ? route : "/guest$route",
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: GetX<ActivityRequestedTripViewController>(
        init: ActivityRequestedTripViewController(trip: trip),
        builder: (controller) {
          TripResponse selected = controller.state.trip.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ActivityRequestedTripViewHeader(controller: controller),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      if(selected.amount.isNotEmpty) ...[
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
                              const SizedBox(height: 10),
                              SText(
                                text: selected.amount,
                                size: Sizing.font(14),
                                color: Theme.of(context).primaryColor
                              ),
                            ]
                          ),
                        )
                      ],
                      ActivityRequestedTripViewProblem(controller: controller),
                      if(selected.provider != null) ...[
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
                      if(selected.quotations.isNotEmpty) ...[
                        Container(
                          padding: EdgeInsets.all(Sizing.space(12)),
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          width: MediaQuery.sizeOf(context).width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SText(
                                text: 'Quotation',
                                size: Sizing.font(14),
                                weight: FontWeight.bold,
                                color: Theme.of(context).primaryColor
                              ),
                              const SizedBox(height: 10),
                              ...selected.quotations.map((quotation) {
                                return ActivityTripQuotation(
                                  quotation: quotation,
                                  trip: selected.id,
                                  onRemoved: () => controller.removeQuotation(quotation),
                                  onAccepted: controller.removeTrip,
                                  onUpdated: controller.updateTrip,
                                );
                              })
                            ]
                          ),
                        )
                      ],
                    ],
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: LoadingButton(
                  text: "Cancel",
                  buttonColor: CommonColors.error,
                  textColor: CommonColors.lightTheme,
                  borderRadius: 24,
                  onClick: () => ActivityTripCancel.open(
                    trip: selected.id,
                    isInvite: selected.isRequest,
                    onSuccess: controller.cancelTrip
                  ),
                  width: MediaQuery.sizeOf(context).width,
                ),
              )
            ],
          );
        },
      )
    );
  }
}