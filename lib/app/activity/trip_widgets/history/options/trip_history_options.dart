import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class TripHistoryOptions extends StatelessWidget {
  final TripResponse trip;
  const TripHistoryOptions({super.key, required this.trip});

  static void open(TripResponse trip) => Navigate.bottomSheet(
    sheet: TripHistoryOptions(trip: trip),
    route: "/activity/history?tab=trip&id=${trip.id}",
    background: Colors.transparent,
    isScrollable: true
  );

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      child: GetBuilder<TripHistoryOptionsController>(
        init: TripHistoryOptionsController(trip: trip),
        builder: (controller) {
          return Obx(() {
            TripResponse active = controller.state.trip.value;
            final list = controller.historyOptions(context);

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(Sizing.space(2)),
                      margin: EdgeInsets.all(Sizing.space(6)),
                      width: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.circular(16)
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: SText(
                      text: "Trip Options for ${active.id.replaceAll("STRIP-", "#").substring(0, 8).toUpperCase()}",
                      size: Sizing.font(16),
                      weight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...list.map((option) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SText(
                          text: option.header,
                          size: Sizing.font(12),
                          weight: FontWeight.bold,
                          color: Theme.of(context).primaryColor
                        ),
                        const SizedBox(height: 8),
                        ...option.options.map((button) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: option.options.length - 1 != button.index ? 8 : 0),
                            child: NavigatorButton(
                              header: button.header,
                              detail: button.body,
                              prefixIcon: button.icon,
                              iconColor: button.color,
                              headerSize: 14,
                              onPressed: () => controller.act(button.index),
                            ),
                          );
                        }),
                        if(list.length - 1 != list.indexOf(option)) ...[
                          Divider(color: Theme.of(context).colorScheme.surface, thickness: 10),
                          const SizedBox(height: 8)
                        ]
                      ],
                    );
                  })
                ],
              )
            );
          });
        }
      )
    );
  }
}