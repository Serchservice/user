import 'package:user/library.dart';

class HomeEvent implements HomeEventService {
  final HomeController controller;
  HomeEvent({required this.controller});

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

  @override
  void addCallEvent(CallController call) {
    List<ActiveEvent> events = List.from(controller.state.events);

    int existingIndex = events.indexWhere((i) => i.call != null && i.call!.state.call.value.channel == call.state.call.value.channel);
    if (existingIndex != -1) {
      events[existingIndex] = ActiveEvent(call: call);
    } else {
      events.add(ActiveEvent(call: call));
    }

    controller.state.events.value = events;
  }

  @override
  void removeCallEventByChannel(String channel) {
    List<ActiveEvent> events = List.from(controller.state.events);

    // Remove events with matching channel
    events.removeWhere((event) => event.call != null && event.call!.state.call.value.channel == channel);

    // Update state with the updated events list
    controller.state.events.value = events;
  }
}