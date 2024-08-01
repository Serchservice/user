import 'package:user/library.dart';

/// Abstract service for managing home activity functionality, including filters and schedules.
abstract class GuestHomeActivityService {
  /// Fetches the invites.
  ///
  /// @param showLoader Indicates if a loader should be shown while fetching the invites. Defaults to true.
  void fetchInvites({bool showLoader = true});

  /// Adds an invite to the list.
  ///
  /// @param response The [TripResponse] to be added.
  void addToInvite(TripResponse response);

  /// Removes an invite from the list.
  ///
  /// @param response The [TripResponse] to be removed.
  void removeFromInvite(TripResponse response);

  /// Fetches the trips.
  ///
  /// @param showLoader Indicates if a loader should be shown while fetching the trips. Defaults to true.
  void fetchTrips({bool showLoader = true});

  /// Prepares the trips from the given data.
  ///
  /// @param data List of Map<String, dynamic> to be converted to [Trip] model.
  void prepareTrips(List<dynamic> data);

  /// Prepares a trip from the given data.
  ///
  /// @param data Map<String, dynamic> to be converted to [Trip] model.
  void prepareTrip(dynamic data);

  /// Adds an trip to the list.
  ///
  /// @param response The [TripResponse] to be added.
  void addToActiveTrips(TripResponse response);

  /// Removes an trip from the list.
  ///
  /// @param response The [TripResponse] to be removed.
  void removeFromActiveTrips(TripResponse response);

  /// Adds an trip to the history.
  ///
  /// @param response The [TripResponse] to be added.
  void addToTripHistory(TripResponse response);

  /// Removes an trip from the history.
  ///
  /// @param response The [TripResponse] to be removed.
  void removeFromTripHistory(TripResponse response);
}