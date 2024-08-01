import 'package:flutter/widgets.dart';
import 'package:user/library.dart';

/// Abstract service for managing home activity functionality, including filters and schedules.
abstract class HomeActivityService {

  /// Gets the list of activity filter buttons.
  ///
  /// @return A [List] of [ButtonView] objects representing the available filters.
  List<ButtonView> get activities;

  /// Gets the list of schedule history filter buttons.
  ///
  /// @return A [List] of [ButtonView] objects representing the available schedules.
  List<ButtonView> get scheduleHistory;

  /// Gets the list of schedule (active or requested) filter buttons.
  ///
  /// @return A [List] of [ButtonView] objects representing the available schedules.
  List<ButtonView> get commons;

  /// Gets the list of share filters.
  ///
  /// @return A [List] of [ButtonView] objects representing the available schedules.
  List<ButtonView> get share;

  /// Filters the schedule history based on the given index.
  ///
  /// @param index The index of the filter to apply.
  void filterScheduleHistoryByStatus(int index);

  /// Filters the schedule history by category based on the given index.
  ///
  /// @param index The index of the filter to apply.
  void filterScheduleHistoryByCategory(int index);

  /// Clears the specified filter.
  ///
  /// @param isSchedule Indicates if the schedule filter should be cleared. If false, clears the other filters.
  void clearFilter(bool isSchedule);

  /// Picks a date for filtering.
  ///
  /// @param isSchedule Indicates if the date filter is for schedules. If false, applies to other filters.
  /// @param context The [BuildContext] to use for the date picker dialog.
  void pickDate({required bool isSchedule, required BuildContext context});

  /// Filters active schedules based on the given index.
  ///
  /// @param index The index of the filter to apply.
  void filterActive(int index);

  /// Filters history based on the given index.
  ///
  /// @param index The index of the filter to apply.
  void filterHistory(int index);

  /// Filters requests based on the given index.
  ///
  /// @param index The index of the filter to apply.
  void filterRequest(int index);

  /// Fetches the schedules.
  ///
  /// @param showLoader Indicates if a loader should be shown while fetching the schedules. Defaults to true.
  void fetchSchedules({bool showLoader = true});

  /// Updates the schedule list
  ///
  /// @param data List of Map<String, dynamic> to be converted to [Schedule] model.
  void updateSchedules(List<dynamic> data);

  /// Updates the schedule group list.
  ///
  /// @param data List of Map<String, dynamic> to be converted to [ScheduleGroup] model.
  void updateScheduleGroups(List<dynamic> data);

  /// Filters requested schedules by category based on the given index.
  ///
  /// @param index The index of the filter to apply.
  void filterRequestedSchedulesByCategory(int index);

  /// Filters active schedules by category based on the given index.
  ///
  /// @param index The index of the filter to apply.
  void filterActiveSchedulesByCategory(int index);

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

  /// Filters active trips by category based on the given index.
  ///
  /// @param index The index of the filter to apply.
  void filterActiveTripsByCategory(int index);

  /// Adds an trip to the list.
  ///
  /// @param response The [TripResponse] to be added.
  void addToActiveTrips(TripResponse response);

  /// Removes an trip from the list.
  ///
  /// @param response The [TripResponse] to be removed.
  void removeFromActiveTrips(TripResponse response);

  /// Filters requested trips by category based on the given index.
  ///
  /// @param index The index of the filter to apply.
  void filterRequestedTripsByCategory(int index);

  /// Filters trip history based on the given index.
  ///
  /// @param index The index of the filter to apply.
  void filterTripHistoryBySharing(int index);

  /// Filters trip history by category based on the given index.
  ///
  /// @param index The index of the filter to apply.
  void filterTripHistoryByCategory(int index);

  /// Adds an trip to the history.
  ///
  /// @param response The [TripResponse] to be added.
  void addToTripHistory(TripResponse response);

  /// Removes an trip from the history.
  ///
  /// @param response The [TripResponse] to be removed.
  void removeFromTripHistory(TripResponse response);
}