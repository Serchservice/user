import 'package:flutter/material.dart';
import 'package:user/library.dart';
import 'package:get/get.dart';

class ActivityScheduleAction extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback? onCancelled;
  final VoidCallback? onStarted;

  const ActivityScheduleAction({super.key, required this.schedule, this.onCancelled, this.onStarted});

  static void open({required Schedule schedule, VoidCallback? onCancelled, VoidCallback? onStarted}) {
    Navigate.bottomSheet(
      sheet: ActivityScheduleAction(schedule: schedule, onStarted: onStarted, onCancelled: onCancelled,),
      route: "/activity/sheet/${schedule.id}",
      isScrollable: true,
      safeArea: false
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      child: GetBuilder<ActivityScheduleActionController>(
        init: ActivityScheduleActionController(
          schedule: schedule,
          onScheduleCancelled: onCancelled,
          onScheduleStarted: onStarted
        ),
        builder: (controller) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SText(
                          text: "Created ${schedule.label} for ${schedule.time}",
                          size: Sizing.font(22),
                          weight: FontWeight.bold,
                          color: Theme.of(context).primaryColor
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Avatar(radius: 12, avatar: schedule.avatar),
                            const SizedBox(width: 6),
                            Expanded(
                              child: SText(
                                text: schedule.name,
                                size: Sizing.font(12),
                                color: Theme.of(context).primaryColor
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: EdgeInsets.all(Sizing.space(4)),
                          decoration: BoxDecoration(
                            color: schedule.backgroundColor,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: SText(
                            text: schedule.status,
                            color: schedule.textColor,
                            size: Sizing.font(12),
                            weight: FontWeight.bold
                          )
                        ),
                        const SizedBox(height: 6),
                        RatingIcon(rating: schedule.rating)
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  CategoryImage(image: schedule.image)
                ],
              ),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Image.asset(
                      Media.logo,
                      width: 60,
                      height: 60,
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: SText(
                      text: schedule.closedBy,
                      size: Sizing.font(14),
                      weight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              SText(
                text: schedule.reason,
                size: Sizing.font(16),
                color: Theme.of(context).primaryColor
              ),
              if(schedule.closedAt.isNotEmpty) ...[
                const SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(Sizing.space(8)),
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SummaryItem(title: "Closed at", value: schedule.closedAt),
                      SummaryItem(title: "Closed on time", value: schedule.closedOnTime ? "YES" : "NO")
                    ],
                  )
                )
              ],
              const SizedBox(height: 15),
              if(schedule.isPending) ...[
                Obx(() => LoadingButton(
                  text: "Cancel schedule",
                  loading: controller.state.isCancelling.value,
                  padding: EdgeInsets.all(Sizing.space(12)),
                  borderRadius: 24,
                  onClick: controller.cancel,
                  buttonColor: CommonColors.error,
                  textColor: CommonColors.lightTheme,
                  width: MediaQuery.sizeOf(context).width
                )),
              ] else if(schedule.isAccepted) ...[
                Obx(() => LoadingButton(
                  text: "Start trip",
                  loading: controller.state.isStarting.value,
                  padding: EdgeInsets.all(Sizing.space(12)),
                  borderRadius: 24,
                  onClick: controller.start,
                  width: MediaQuery.sizeOf(context).width
                )),
              ]
            ],
          );
        }
      )
    );
  }
}