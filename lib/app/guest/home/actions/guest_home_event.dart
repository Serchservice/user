import 'package:user/library.dart';

class GuestHomeEvent implements GuestHomeEventService {
  final GuestHomeController controller;
  GuestHomeEvent({required this.controller});

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