import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class RequestedTripView extends StatelessWidget {
  final TripResponse trip;
  const RequestedTripView({super.key, required this.trip});

  static void open(TripResponse trip) {
    Navigate.toPage(
      widget: RequestedTripView(trip: trip),
      route: "/activity/trip/request?id=${trip.id}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: GetX<RequestedTripViewController>(
        init: RequestedTripViewController(trip: trip),
        builder: (controller) {
          TripResponse selected = controller.state.trip.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(Sizing.space(12)),
                color: Theme.of(context).appBarTheme.backgroundColor,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const GoBack(size: 30, radius: 10, icon: Icons.arrow_back),
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SText(
                            text: "You are requesting for ${CommonUtility.textWithAorAn(selected.category)}",
                            size: Sizing.font(18),
                            weight: FontWeight.bold,
                            color: Theme.of(context).primaryColor
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          padding: EdgeInsets.all(Sizing.space(4)),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: CategoryImage(image: selected.image, width: 60, height: 60)
                        ),
                      ],
                    ),
                  ],
                )
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.all(Sizing.space(12)),
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        width: MediaQuery.of(context).size.width,
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
                        const SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.all(Sizing.space(12)),
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          width: MediaQuery.of(context).size.width,
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
                      if(selected.problem.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.all(Sizing.space(12)),
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SText(
                                text: 'Problem Description',
                                size: Sizing.font(14),
                                weight: FontWeight.bold,
                                color: Theme.of(context).primaryColor
                              ),
                              const SizedBox(height: 10),
                              SText(
                                text: selected.problem,
                                size: Sizing.font(14),
                                color: Theme.of(context).primaryColor
                              ),
                            ]
                          ),
                        )
                      ] else if(selected.audio.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.all(Sizing.space(12)),
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              SText(
                                text: 'Problem Description',
                                size: Sizing.font(14),
                                weight: FontWeight.bold,
                                color: Theme.of(context).primaryColor
                              ),
                              const SizedBox(height: 10),
                              Obx(() => Slider(
                                value: controller.state.currentPosition.value,
                                max: controller.state.totalDuration.value,
                                onChanged: controller.seek,
                                activeColor: Theme.of(context).primaryColorLight,
                                inactiveColor: CommonColors.shimmerBase.withOpacity(.48),
                                thumbColor: Theme.of(context).primaryColor,
                              )),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(() => SText(
                                    text: controller.playingTime(),
                                    color: Theme.of(context).primaryColor
                                  )),
                                  Obx(() => CircledButton(
                                    icon: controller.state.isPlaying.value ? Icons.pause : Icons.play_arrow,
                                    title: controller.state.isPlaying.value ? "Pause" : "Play",
                                    iconColor: Theme.of(context).primaryColor,
                                    onClick: controller.state.isPlaying.value ? controller.pauseAudio : controller.playAudio,
                                  )),
                                ],
                              ),
                            ]
                          ),
                        )
                      ] else ...[
                        const SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.all(Sizing.space(12)),
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SText(
                                text: 'Problem Description',
                                size: Sizing.font(14),
                                weight: FontWeight.bold,
                                color: Theme.of(context).primaryColor
                              ),
                              const SizedBox(height: 10),
                              SText(
                                text: "This request was made based on the discussion you had with the provider involved."
                                  " Waiting for the response to start trip.",
                                size: Sizing.font(14),
                                color: Theme.of(context).primaryColor
                              ),
                            ]
                          ),
                        )
                      ],
                      if(selected.provider != null) ...[
                        const SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.all(Sizing.space(12)),
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          width: MediaQuery.of(context).size.width,
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
                              TripProfile(user: selected.provider!, needPhone: false)
                            ]
                          ),
                        )
                      ],
                      if(selected.quotations.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.all(Sizing.space(12)),
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SText(
                                text: 'Quotations',
                                size: Sizing.font(14),
                                weight: FontWeight.bold,
                                color: Theme.of(context).primaryColor
                              ),
                              const SizedBox(height: 10),
                              ...selected.quotations.map((quotation) {
                                return QuotationView(
                                  quotation: quotation,
                                  trip: selected.id,
                                  onRemove: () => controller.removeQuotation(quotation),
                                  onAccept: controller.removeTrip,
                                  onUpdate: controller.updateTrip,
                                );
                              })
                            ]
                          ),
                        )
                      ],
                      const SizedBox(height: 5),
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
                  onClick: () => CancelTripSheet.open(
                    trip: selected.id,
                    isInvite: selected.isRequest,
                    onSuccess: controller.cancelTrip
                  ),
                  width: MediaQuery.of(context).size.width,
                ),
              )
            ],
          );
        },
      )
    );
  }
}
