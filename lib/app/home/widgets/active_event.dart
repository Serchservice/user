import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class ActiveEvent extends StatelessWidget {
  final CallController? call;
  final TripResponse? trip;

  const ActiveEvent({super.key, this.trip, this.call});
      // : assert ((call != null && trip == null) || (call == null && trip != null));

  ActiveEvent copyWith({TripResponse? trip, CallController? call}) {
    return ActiveEvent(trip: trip ?? this.trip, call: call ?? this.call);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(trip != null ? 12 : 24),
      child: Material(
        color: trip != null ? Theme.of(context).textSelectionTheme.selectionColor : CommonColors.success,
        child: _buildBody(context)
      )
    );
  }

  Widget _buildBody(BuildContext context) {
    if(call != null) {
      return _buildCallEvent(context);
    } else if(trip != null) {
      return _buildTripEvent(context);
    } else {
      return Container();
    }
  }

  Widget _buildCallEvent(BuildContext context) {
    return Obx(() {
      ActiveCallResponse active = call!.state.call.value;

      return InkWell(
        onTap: () => RouteNavigator.goToCall(removeCurrentRoute: false, call: active),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Avatar.medium(avatar: active.avatar),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Avatar(radius: 13, avatar: active.image)
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SText(
                      text: active.name,
                      size: Sizing.font(16),
                      color: CommonColors.lightTheme,
                      flow: TextOverflow.ellipsis
                    ),
                    SText(
                      text: CommonUtility.capitalizeWords(active.status.type),
                      size: Sizing.font(11.5),
                      color: CommonColors.lightTheme,
                      flow: TextOverflow.ellipsis
                    )
                  ]
                )
              ),
              const SizedBox(width: 5),
              Image.asset(
                active.isVoice ? Media.voiceCall : Media.tip2fixCall,
                width: Sizing.space(25),
                height: Sizing.space(25),
              )
            ]
          )
        ),
      );
    });
  }

  Widget _buildTripEvent(BuildContext context) {
    return InkWell(
      onTap: () {
        if(Database.isUserActive) {
          ActiveTripView.open(trip!);
        } else {
          GuestActiveTripView.open(trip!);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SText(
                    text: "You are on a trip with ${CommonUtility.textWithAorAn(trip!.category)}",
                    size: Sizing.font(16),
                    weight: FontWeight.bold,
                    color: Theme.of(context).primaryColor
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  padding: EdgeInsets.all(Sizing.space(4)),
                  decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: CategoryImage(image: trip!.image, width: 40, height: 40)
                ),
              ],
            ),
            if(trip!.timelines.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: trip!.timelines.map((timeline) {
                  bool showSpacer = trip!.timelines[trip!.timelines.length - 1] != timeline;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: showSpacer ? 8.0 : 0),
                      child: TripStep(
                        header: timeline.header,
                        description: timeline.description,
                        label: timeline.label,
                        isOver: timeline.isOver,
                        isVertical: false,
                      ),
                    )
                  );
                }).toList(),
              )
            ],
          ],
        ),
      ),
    );
  }
}