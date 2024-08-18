import 'package:user/library.dart';

/// Abstract service for managing home event functionality, including preparing and updating call events.
abstract class HomeEventService {
  /// Adds a new call event to the home event service.
  ///
  /// @param controller The [CallController] to be added.
  void addCallEvent(CallController call);

  /// Removes a call event from the home event service based on the channel.
  ///
  /// @param channel The channel associated with the call event to be removed.
  void removeCallEventByChannel(String channel);

  /// Adds a new trip event to the home event service.
  ///
  /// @param trip The [TripResponse] to be added.
  void addTripEvent(TripResponse trip);

  /// Removes a trip event from the home event service based on the trip ID.
  ///
  /// @param id The ID associated with the trip event to be removed.
  void removeTripEventById(String id);
}