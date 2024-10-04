import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ScheduleTimeViewer extends StatefulWidget {
  final Schedule schedule;
  final VoidCallback? onCancel;
  const ScheduleTimeViewer({super.key, required this.schedule, this.onCancel});

  static void open({required Schedule schedule, VoidCallback? onCancel}) {
    Navigate.bottomSheet(
      sheet: ScheduleTimeViewer(schedule: schedule, onCancel: onCancel,),
      route: "/schedule/view?id=${schedule.id}",
      isScrollable: true,
      safeArea: false
    );
  }

  @override
  State<ScheduleTimeViewer> createState() => _ScheduleTimeViewerState();
}

class _ScheduleTimeViewerState extends State<ScheduleTimeViewer> {
  final ConnectService _connect = Connect();

  late Schedule schedule;
  bool isCancelling = false;
  bool isStarting = false;

  @override
  void initState() {
    schedule = widget.schedule;
    super.initState();
  }

  void cancel() async {
    setState(() => isCancelling = true);
    var response = await _connect.patch(endpoint: "/schedule/cancel/${schedule.id}", body: {});
    setState(() => isCancelling = false);
    if(response.isOk) {
      HomeController.data.activity.fetchSchedules(showLoader: false);
      widget.onCancel?.call();
    } else {
      notify.error(message: response.message);
    }
  }

  void start() async {
    setState(() => isStarting = true);
    var response = await _connect.patch(endpoint: "/schedule/start/${schedule.id}", body: {});
    setState(() => isStarting = false);
    if(response.isOk) {
      HomeController.data.activity.fetchSchedules(showLoader: false);
      TripResponse trip = TripResponse.fromJson(response.data);
      HomeController.data.activity.addToInvite(trip);

      Navigate.till(ModalRoute.withName(HomeLayout.route));
      RequestedTripView.open(trip);
    } else {
      notify.error(message: response.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      child: Column(
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
                        color: background(schedule.status),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: SText(
                        text: schedule.status,
                        color: text(schedule.status),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SText(
                    text: "Closed At:       ${schedule.closedAt}",
                    size: Sizing.font(14),
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 5),
                  SText(
                    text: "Closed on time:  ${schedule.closedOnTime}",
                    size: Sizing.font(14),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              )
            )
          ],
          const SizedBox(height: 15),
          if(schedule.status.toLowerCase() == "pending") ...[
            LoadingButton(
              text: "Cancel schedule",
              loading: isCancelling,
              padding: EdgeInsets.all(Sizing.space(12)),
              borderRadius: 24,
              onClick: cancel,
              buttonColor: CommonColors.error,
              textColor: CommonColors.lightTheme,
              width: MediaQuery.sizeOf(context).width
            ),
          ] else if(schedule.status.toLowerCase() == "accepted") ...[
            LoadingButton(
              text: "Start trip",
              loading: isStarting,
              padding: EdgeInsets.all(Sizing.space(12)),
              borderRadius: 24,
              onClick: start,
              width: MediaQuery.sizeOf(context).width
            ),
          ]
        ],
      )
    );
  }

  Color background(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return const Color(0xFFD3D3D3); // Light Gray
      case "accepted":
        return const Color(0xFFD4EDDA); // Light Green
      case "declined":
        return const Color(0xFFF8D7DA); // Light Red
      case "closed":
        return const Color(0xFFD1ECF1); // Light Blue
      case "attended":
        return const Color(0xFFFFF3CD); // Light Yellow
      case "cancelled":
        return const Color(0xFFFFE5B4); // Light Orange
      case "unattended":
        return const Color(0xFFE2D4F0); // Light Purple
      default:
        return Colors.white; // Default to white if status is unknown
    }
  }

  Color text(String status) {
    switch (status.toLowerCase()) {
      case "pending":
      case "accepted":
      case "declined":
      case "closed":
      case "attended":
      case "cancelled":
      case "unattended":
        return const Color(0xFF050404); // Black
      default:
        return Colors.black; // Default to black if status is unknown
    }
  }
}