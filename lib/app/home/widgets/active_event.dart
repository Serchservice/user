import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:user/library.dart';

class ActiveEvent extends StatelessWidget {
  final CallController? callController;
  final TripResponse? trip;

  const ActiveEvent({super.key, this.callController, this.trip})
      : assert ((callController != null && trip == null) || (callController == null && trip != null));

  ActiveEvent copyWith({CallController? callController}) {
    return ActiveEvent(callController: callController ?? this.callController);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Material(
        color: CommonColors.success,
        child: _buildBody(context)
      )
    );
  }

  Widget _buildBody(BuildContext context) {
    if(callController != null) {
      return _buildCallEvent(context);
    } else if(trip != null) {
      return _buildTripEvent(context);
    } else {
      return Container();
    }
  }

  Widget _buildCallEvent(BuildContext context) {
    return InkWell(
      onTap: () => RouteNavigator.goToCall(removeCurrentRoute: false, call: callController!.state.call.value),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() => Avatar.medium(avatar: callController!.state.call.value.avatar)),
            const SizedBox(width: 15),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => SText(
                    text: callController!.state.call.value.name,
                    size: Sizing.font(16),
                    color: CommonColors.lightTheme,
                    flow: TextOverflow.ellipsis
                  )),
                  Obx(() => SText(
                    text: CommonUtility.capitalizeWords(callController!.state.call.value.status.type),
                    size: Sizing.font(11.5),
                    color: CommonColors.lightTheme,
                    flow: TextOverflow.ellipsis
                  ))
                ]
              )
            ),
            const SizedBox(width: 5),
            Obx(() {
              if(callController!.state.call.value.isCalling || callController!.state.call.value.isRinging) {
                return Image.asset(
                  callController!.state.call.value.isVoice ? Media.voiceCall : Media.tip2fixCall,
                  width: Sizing.space(18),
                  height: Sizing.space(18),
                );
              } else {
                return SText(text: "", size: Sizing.font(11));
              }
            })
          ]
        )
      ),
    );
  }

  Widget _buildTripEvent(BuildContext context) {
    return InkWell(
      onTap: () {
        if(Database.isUserLoggedIn) {
          ActiveTripView.open(trip!);
        } else {
          GuestActiveTripView.open(trip!);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SText(
                text: "You are on a trip with ${CommonUtility.textWithAorAn(trip!.category)}",
                size: Sizing.font(18),
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
              child: CategoryImage(image: trip!.image, width: 60, height: 60)
            ),
          ],
        ),
      ),
    );
  }
}