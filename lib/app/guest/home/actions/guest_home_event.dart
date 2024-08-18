import 'package:user/library.dart';

class GuestHomeEvent implements GuestHomeEventService {
  final GuestHomeController controller;
  GuestHomeEvent({required this.controller});

  @override
  void addTripEvent(TripResponse trip) {
    List<ActiveEvent> events = List.from(controller.state.events);

    int existingIndex = events.indexWhere((i) => i.trip != null && i.trip!.id == trip.id);
    if (existingIndex != -1) {
      events[existingIndex] = ActiveEvent(trip: trip);
    } else {
      events.add(ActiveEvent(trip: trip));
    }

    // Update state with the new events list
    controller.state.events.value = events;
  }

  @override
  void removeTripEventById(String id) {
    List<ActiveEvent> events = List.from(controller.state.events);

    // Remove events with matching channel
    events.removeWhere((event) => event.trip != null && event.trip!.id == id);

    // Update state with the updated events list
    controller.state.events.value = events;
  }
}