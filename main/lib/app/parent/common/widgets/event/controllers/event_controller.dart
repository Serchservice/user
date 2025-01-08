import 'package:user/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventController extends GetxController {
  EventController();
  static EventController get data => Get.find<EventController>();

  final state = EventState();

  void addTrip(TripResponse trip) {
    List<ActiveEvent> events = List.from(state.events);

    int existingIndex = events.indexWhere((i) => i.trip != null && i.trip!.id == trip.id);
    if (existingIndex != -1) {
      events[existingIndex] = ActiveEvent(trip: trip);
    } else {
      events.add(ActiveEvent(trip: trip));
    }

    // Update state with the new events list
    state.events.value = events;
  }

  void removeTripById(String id) {
    List<ActiveEvent> events = List.from(state.events);

    // Remove events with matching channel
    events.removeWhere((event) => event.trip != null && event.trip!.id == id);

    // Update state with the updated events list
    state.events.value = events;
  }

  void addCall(CallController call) {
    List<ActiveEvent> events = List.from(state.events);

    int existingIndex = events.indexWhere((i) => i.call != null && i.call!.state.call.value.channel == call.state.call.value.channel);
    if (existingIndex != -1) {
      events[existingIndex] = ActiveEvent(call: call);
    } else {
      events.add(ActiveEvent(call: call));
    }

    state.events.value = events;
  }

  void removeCallByChannel(String channel) {
    List<ActiveEvent> events = List.from(state.events);

    // Remove events with matching channel
    events.removeWhere((event) => event.call != null && event.call!.state.call.value.channel == channel);

    // Update state with the updated events list
    state.events.value = events;
  }

  Widget? buildButton() {
    if(state.isMinimized.value && state.events.isNotEmpty) {
      return FloatingActionButton(
        onPressed: state.isMinimized.toggle,
        tooltip: "Show active events",
        backgroundColor: CommonColors.success,
        child: const Icon(
          Icons.open_in_full_rounded,
          color: CommonColors.lightTheme
        ),
      );
    } else {
      return null;
    }
  }

  Widget? buildLayout() {
    if(state.isMinimized.value) {
      return null;
    } else if(state.events.isNotEmpty) {
      double space = Sizing.space(8);

      return Container(
        constraints: BoxConstraints(maxHeight: Get.height / 2),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LoadingButton(
                    text: state.isMinimized.value ? "View details" : "Minimize details",
                    buttonColor: Get.theme.colorScheme.surface,
                    textColor: Get.theme.primaryColor,
                    textSize: 12,
                    borderRadius: 30,
                    padding: EdgeInsets.all(Sizing.space(6)),
                    onClick: state.isMinimized.toggle,
                  )
                ],
              ),
              const SizedBox(height: 10),
              ...state.events.map((event) {
                bool isLast = state.events.length - 1 == state.events.indexOf(event);

                return Padding(
                  padding: isLast
                      ? EdgeInsets.symmetric(horizontal: space)
                      : EdgeInsets.only(bottom: space, left: space, right: space),
                  child: Swiper(
                    onLeftSwipe: (details) {
                      if(event.trip != null) {
                        removeTripById(event.trip!.id);
                      } else if(event.call != null) {
                        removeCallByChannel(event.call!.state.call.value.channel);
                      }
                    },
                    iconOnLeftSwipe: CupertinoIcons.trash,
                    iconOnRightSwipe: CupertinoIcons.trash,
                    iconSize: 16,
                    iconColor: CommonColors.error,
                    onRightSwipe: (details) {
                      if(event.trip != null) {
                        removeTripById(event.trip!.id);
                      } else if(event.call != null) {
                        removeCallByChannel(event.call!.state.call.value.channel);
                      }
                    },
                    child: event
                  )
                );
              })
            ],
          ),
        ),
      );
    } else {
      return null;
    }
  }
}