import 'package:user/library.dart';

/// Abstract service for managing home event functionality, including preparing and updating call events.
abstract class GuestHomeEventService {
  /// Adds a new trip event to the home event service.
  ///
  /// @param trip The [TripResponse] to be added.
  void addTripEvent(TripResponse trip);

  /// Removes a trip event from the home event service based on the trip ID.
  ///
  /// @param id The ID associated with the trip event to be removed.
  void removeTripEventById(String id);
}