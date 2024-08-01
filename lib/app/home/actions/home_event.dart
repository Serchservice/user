import 'package:user/library.dart';

class HomeEvent implements HomeEventService {
  final HomeController controller;
  HomeEvent({required this.controller});

  @override
  void addCallEvent(CallController callController) {
    List<ActiveEvent> events = controller.state.events;

    if(events.isEmpty) {
      events.add(ActiveEvent(callController: callController));
    } else {
      // Check if there is an event with the same channel
      bool updatedExisting = false;
      for (int i = 0; i < events.length; i++) {
        if (events[i].callController != null && events[i].callController!.state.call.value.channel == callController.state.call.value.channel) {
          // Update existing event
          events[i] = ActiveEvent(callController: callController);
          updatedExisting = true;
          break;
        }
      }

      // If no existing event was updated, add a new one
      if (!updatedExisting) {
        events.add(ActiveEvent(callController: callController));
      }
    }

    // Update state with the new events list
    controller.state.events.value = events;
  }

  @override
  void removeCallEventByChannel(String channel) {
    List<ActiveEvent> events = controller.state.events;

    // Remove events with matching channel
    events.removeWhere((event) {
      return event.callController != null && event.callController!.state.call.value.channel == channel;
    });

    // Update state with the updated events list
    controller.state.events.value = events;
  }

  @override
  void addTripEvent(TripResponse trip) {
    List<ActiveEvent> events = controller.state.events;

    if(events.isEmpty) {
      events.add(ActiveEvent(trip: trip));
    } else {
      // Check if there is an event with the same channel
      bool updatedExisting = false;
      for (int i = 0; i < events.length; i++) {
        if (events[i].trip != null && events[i].trip!.id == trip.id) {
          // Update existing event
          events[i] = ActiveEvent(trip: trip);
          updatedExisting = true;
          break;
        }
      }

      // If no existing event was updated, add a new one
      if (!updatedExisting) {
        events.add(ActiveEvent(trip: trip));
      }
    }

    // Update state with the new events list
    controller.state.events.value = events;
  }

  @override
  void removeTripEventById(String id) {
    List<ActiveEvent> events = controller.state.events;

    // Remove events with matching channel
    events.removeWhere((event) => event.trip != null && event.trip!.id == id);

    // Update state with the updated events list
    controller.state.events.value = events;
  }
}