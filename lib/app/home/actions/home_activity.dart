import 'package:flutter/material.dart';
import 'package:user/library.dart';

class HomeActivity implements HomeActivityService {
  final HomeController controller;
  HomeActivity({required this.controller});

  final ConnectService _connect = Connect();

  @override
  void clearFilter(bool isSchedule) {
    if (isSchedule) {
      controller.state.selectedScheduleHistoryFilterDate.value = DateTime(2009);
      controller.state.selectedScheduleHistoryFilterStatus.value = "";
      controller.state.historyScheduleFilter.value = 0;
      controller.state.selectedScheduleHistoryFilterCategory.value = "";
      controller.state.historyScheduleCategoryFilter.value = 0;
      controller.state.filteredHistorySchedules.value = controller.state.scheduleHistory;
    } else {
      controller.state.selectedTripHistoryFilterDate.value = DateTime(2009);
      controller.state.selectedTripHistoryShareFilter.value = "";
      controller.state.historyTripShareFilter.value = 0;
      controller.state.tripHistoryFilterCategory.value = "";
      controller.state.historyTripCategoryFilter.value = 0;
      controller.state.filteredTripHistory.value = controller.state.tripHistory;
    }
  }

  @override
  void fetchSchedules({bool showLoader = true}) async {
    if(showLoader) {
      controller.state.isFetchingSchedules.value = true;
    }
    var responses = [
      await _connect.get(endpoint: "/schedule/all"),
      await _connect.get(endpoint: "/schedule/all/active")
    ];
    if(responses.any((response) => !response.isOk)) {
      notify.error(message: responses.where((res) => !res.isOk).first.message);
    } else {
      List<dynamic> all = responses.first.data;
      List<ScheduleGroup> scheduleGroups = all.map((e) => ScheduleGroup.fromJson(e)).toList();
      controller.state.scheduleHistory.value = scheduleGroups;
      _applyCombinedScheduleHistoryFilters();

      List<dynamic> active = responses.last.data;
      List<Schedule> schedules = active.map((e) => Schedule.fromJson(e)).toList();
      controller.state.schedules.value = schedules;
      filterActiveSchedulesByCategory(controller.state.activeScheduleCategoryFilter.value);
      filterRequestedSchedulesByCategory(controller.state.requestedScheduleCategoryFilter.value);
      controller.state.isFetchingSchedules.value = false;
    }
  }

  void _filterScheduleHistoryWithDate(DateTime time) {
    if (time != DateTime(2009)) {
      controller.state.selectedScheduleHistoryFilterDate.value = time;
      _applyCombinedScheduleHistoryFilters();
    }
  }

  void _applyCombinedScheduleHistoryFilters() {
    DateTime filterDate = controller.state.selectedScheduleHistoryFilterDate.value;
    String filterStatus = controller.state.selectedScheduleHistoryFilterStatus.value;
    String category = controller.state.selectedScheduleHistoryFilterCategory.value;

    controller.state.filteredHistorySchedules.value = controller.state.scheduleHistory.map((group) {
      bool matchesDate = filterDate == DateTime(2009) || (group.time != null && CommonUtility.isSameDate(group.time!, filterDate));

      if (matchesDate) {
        List<Schedule> filteredSchedules = group.schedules.where((schedule) {
          bool matchesStatus = filterStatus.isEmpty || schedule.status.toLowerCase() == filterStatus.toLowerCase();
          bool matchesCategory = category.isEmpty || schedule.category.toLowerCase() == category.toLowerCase();
          return matchesStatus && matchesCategory;
        }).toList();

        if (filteredSchedules.isNotEmpty) {
          return group.copyWith(schedules: filteredSchedules);
        }
      }

      return group.copyWith(schedules: []);
    }).where((group) => group.schedules.isNotEmpty).toList();
  }

  @override
  void filterActive(int index) {
    controller.state.activeActivityFilter.value = index;
  }

  @override
  void filterHistory(int index) {
    controller.state.historyActivityFilter.value = index;
  }

  @override
  void filterRequest(int index) {
    controller.state.requestActivityFilter.value = index;
  }

  @override
  void filterScheduleHistoryByStatus(int index) {
    controller.state.historyScheduleFilter.value = index;

    if (index >= 0 && index < scheduleHistory.length) {
      _filterScheduleHistoryWithStatus(scheduleHistory[index].index);
    } else {
      // Handle default case (all items)
      _filterScheduleHistoryWithStatus(0); // Index 0 represents "All" items
    }
  }

  void _filterScheduleHistoryWithStatus(int index) {
    String status;

    switch (index) {
      case 1:
        status = scheduleHistory[1].header.toLowerCase();
        break;
      case 2:
        status = scheduleHistory[2].header.toLowerCase();
        break;
      case 3:
        status = scheduleHistory[3].header.toLowerCase();
        break;
      case 4:
        status = scheduleHistory[4].header.toLowerCase();
        break;
      case 5:
        status = "unattended";
        break;
      default:
        status = ""; // "All" case
        break;
    }

    controller.state.selectedScheduleHistoryFilterStatus.value = status;
    _applyCombinedScheduleHistoryFilters();
  }

  @override
  List<ButtonView> get activities => [
    ButtonView(header: "Trip", index: 0),
    ButtonView(header: "Schedule", index: 1),
  ];

  @override
  void pickDate({required bool isSchedule, required BuildContext context}) async {
    DateTime? result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime.now(),
      routeSettings: RouteSettings(
        name: isSchedule
            ? "/activity?active=history&current=schedule&option=filter&with=date"
            : "/activity?active=history&current=trip&option=filter&with=date",
      ),
    );

    if(result != null) {
      if (isSchedule) {
        _filterScheduleHistoryWithDate(result);
      } else {
        _filterTripHistoryWithDate(result);
      }
    }
  }

  @override
  List<ButtonView> get scheduleHistory => [
    ButtonView(header: "All", index: 0),
    ButtonView(header: "Cancelled", index: 1),
    ButtonView(header: "Attended", index: 2),
    ButtonView(header: "Declined", index: 3),
    ButtonView(header: "Closed", index: 4),
    ButtonView(header: "No trip", index: 5),
  ];

  @override
  void updateSchedules(List<dynamic> data) {
    List<Schedule> list = data.map((schedule) => Schedule.fromJson(schedule)).toList();
    if(list.isNotEmpty) {
      controller.state.schedules.value = list;
      filterScheduleHistoryByCategory(controller.state.historyScheduleCategoryFilter.value);
    }
  }

  @override
  void updateScheduleGroups(List<dynamic> data) {
    List<ScheduleGroup> list = data.map((schedule) => ScheduleGroup.fromJson(schedule)).toList();
    if(list.isNotEmpty) {
      controller.state.scheduleHistory.value = list;
      filterScheduleHistoryByStatus(controller.state.historyScheduleFilter.value);
      _filterScheduleHistoryWithDate(controller.state.selectedScheduleHistoryFilterDate.value);
    }
  }

  @override
  List<ButtonView> get commons => [
    ButtonView(header: "All", index: 0),
    ButtonView(header: "Mechanic", index: 1),
    ButtonView(header: "Plumber", index: 2),
    ButtonView(header: "Electrician", index: 3),
    ButtonView(header: "House Keeper", index: 4),
    ButtonView(header: "Carpenter", index: 5),
  ];

  @override
  void filterScheduleHistoryByCategory(int index) {
    controller.state.historyScheduleCategoryFilter.value = index;
    if (index >= 0 && index < commons.length) {
      _filterScheduleHistoryByCategoryIndex(commons[index].index);
    } else {
      // Handle default case (all items)
      _filterScheduleHistoryByCategoryIndex(0); // Index 0 represents "All" items
    }
  }

  void _filterScheduleHistoryByCategoryIndex(int index) {
    String category;

    switch (index) {
      case 1:
        category = commons[1].header.toLowerCase();
        break;
      case 2:
        category = commons[2].header.toLowerCase();
        break;
      case 3:
        category = commons[3].header.toLowerCase();
        break;
      case 4:
        category = commons[4].header.toLowerCase();
        break;
      case 5:
        category = commons[5].header.toLowerCase();
        break;
      default:
        category = ""; // "All" case
        break;
    }

    controller.state.selectedScheduleHistoryFilterCategory.value = category;
    _applyCombinedScheduleHistoryFilters();
  }

  @override
  void filterActiveSchedulesByCategory(int index) {
    controller.state.activeScheduleCategoryFilter.value = index;
    if (index >= 0 && index < commons.length) {
      _filterActiveSchedulesByCategoryIndex(commons[index].index);
    } else {
      // Handle default case (all items)
      _filterActiveSchedulesByCategoryIndex(0); // Index 0 represents "All" items
    }
  }

  void _filterActiveSchedulesByCategoryIndex(int index) {
    String category;

    switch (index) {
      case 1:
        category = commons[1].header.toLowerCase();
        break;
      case 2:
        category = commons[2].header.toLowerCase();
        break;
      case 3:
        category = commons[3].header.toLowerCase();
        break;
      case 4:
        category = commons[4].header.toLowerCase();
        break;
      case 5:
        category = commons[5].header.toLowerCase();
        break;
      default:
        category = ""; // "All" case
        break;
    }

    controller.state.activeScheduleFilterCategory.value = category;
    if(category.isNotEmpty) {
      controller.state.filteredActiveSchedules.value = controller.state.schedules.where((schedule) {
        return category.toLowerCase() == schedule.category.toLowerCase() && schedule.isAccepted;
      }).toList();
    } else {
      controller.state.filteredActiveSchedules.value = controller.state.schedules.where((schedule) {
        return schedule.isAccepted;
      }).toList();
    }
  }

  @override
  void filterRequestedSchedulesByCategory(int index) {
    controller.state.requestedScheduleCategoryFilter.value = index;
    if (index >= 0 && index < commons.length) {
      _filterRequestedSchedulesByCategoryIndex(commons[index].index);
    } else {
      // Handle default case (all items)
      _filterRequestedSchedulesByCategoryIndex(0); // Index 0 represents "All" items
    }
  }

  void _filterRequestedSchedulesByCategoryIndex(int index) {
    String category;

    switch (index) {
      case 1:
        category = commons[1].header.toLowerCase();
        break;
      case 2:
        category = commons[2].header.toLowerCase();
        break;
      case 3:
        category = commons[3].header.toLowerCase();
        break;
      case 4:
        category = commons[4].header.toLowerCase();
        break;
      case 5:
        category = commons[5].header.toLowerCase();
        break;
      default:
        category = ""; // "All" case
        break;
    }

    controller.state.requestedScheduleFilterCategory.value = category;
    if(category.isNotEmpty) {
      controller.state.filteredRequestedSchedules.value = controller.state.schedules.where((schedule) {
        return category.toLowerCase() == schedule.category.toLowerCase() && schedule.isPending;
      }).toList();
    } else {
      controller.state.filteredRequestedSchedules.value = controller.state.schedules.where((schedule) {
        return schedule.isPending;
      }).toList();
    }
  }

  @override
  void fetchInvites({bool showLoader = true}) async {
    if(showLoader) {
      controller.state.isFetchingTripInvites.value = true;
    }

    var response = await _connect.get(endpoint: "/trip/invite");
    if(response.isSuccessful) {
      controller.state.isFetchingTripInvites.value = false;
      List<dynamic> list = response.data;
      _buildInviteList(list.map((data) => TripResponse.fromJson(data)).toList());
    }
  }

  void _buildInviteList(List<TripResponse> list) {
    controller.state.invites.value = list;
    filterRequestedTripsByCategory(controller.state.inviteTripCategoryFilter.value);
  }

  @override
  void filterRequestedTripsByCategory(int index) {
    controller.state.inviteTripCategoryFilter.value = index;
    if (index >= 0 && index < commons.length) {
      _filterRequestedTripsByCategoryIndex(commons[index].index);
    } else {
      // Handle default case (all items)
      _filterRequestedTripsByCategoryIndex(0); // Index 0 represents "All" items
    }
  }

  void _filterRequestedTripsByCategoryIndex(int index) {
    String category;

    switch (index) {
      case 1:
        category = commons[1].header.toLowerCase();
        break;
      case 2:
        category = commons[2].header.toLowerCase();
        break;
      case 3:
        category = commons[3].header.toLowerCase();
        break;
      case 4:
        category = commons[4].header.toLowerCase();
        break;
      case 5:
        category = commons[5].header.toLowerCase();
        break;
      default:
        category = ""; // "All" case
        break;
    }

    controller.state.inviteFilterCategory.value = category;
    if(category.isNotEmpty) {
      controller.state.filteredInvites.value = controller.state.invites.where((invite) {
        return category.toLowerCase() == invite.category.toLowerCase();
      }).toList();
    } else {
      controller.state.filteredInvites.value = controller.state.invites;
    }
  }

  @override
  void addToInvite(TripResponse response) {
    List<TripResponse> invites = List.from(controller.state.invites); // Create a copy to avoid modifying the controller.state directly
    // Find the index of the existing response
    int existingIndex = invites.indexWhere((i) => i.id == response.id);

    if (existingIndex != -1) {
      // If the response exists, update the existing response
      invites[existingIndex] = response;
    } else {
      // If the response does not exist, add the new response
      invites.add(response);
    }

    // Sort the list based on `sentAt`
    invites.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    // Update the controller.state with the new list
    controller.state.invites.value = invites;
    // Apply the current filter
    filterRequestedTripsByCategory(controller.state.inviteTripCategoryFilter.value);
  }

  @override
  void removeFromInvite(TripResponse response) {
    List<TripResponse> invites = List.from(controller.state.invites); // Create a copy to avoid modifying the controller.state directly
    // Find the index of the existing response
    int existingIndex = invites.indexWhere((i) => i.id == response.id);

    if (existingIndex != -1) {
      // If the response exists, update the existing response
      invites.remove(invites[existingIndex]);
    }

    // Sort the list based on `sentAt`
    invites.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    // Update the controller.state with the new list
    controller.state.invites.value = invites;
    // Apply the current filter
    filterRequestedTripsByCategory(controller.state.inviteTripCategoryFilter.value);
  }

  @override
  void fetchTrips({bool showLoader = true}) async {
    if(showLoader) {
      controller.state.isFetchingTrips.value = true;
    }

    var response = await _connect.get(endpoint: "/trip/history");
    if(response.isSuccessful) {
      controller.state.isFetchingTrips.value = false;
      List<dynamic> list = response.data;
      List<TripResponse> trips = list.map((data) => TripResponse.fromJson(data)).toList();

      _buildActiveTripList(trips.where((d) => d.isActive).toList());
      _buildTripHistoryList(trips.where((d) => d.isClosed || d.isUnfulfilled).toList());
    }
  }

  void _buildActiveTripList(List<TripResponse> list) {
    controller.state.activeTrips.value = list;
    filterActiveTripsByCategory(controller.state.activeTripCategoryFilter.value);

    for(var trip in list) {
      controller.event.addTripEvent(trip);
    }
  }

  void _buildTripHistoryList(List<TripResponse> list) {
    controller.state.tripHistory.value = list;
    _applyCombinedTripHistoryFilters();
  }

  @override
  void prepareTrip(data) {
    TripResponse response = TripResponse.fromJson(data);
    if(response.isWaiting) {
      addToInvite(response);
    } else if(response.isActive) {
      addToActiveTrips(response);
      removeFromInvite(response);
    } else {
      addToTripHistory(response);
      removeFromActiveTrips(response);
    }
  }

  @override
  void prepareTrips(List<dynamic> data) {
    List<TripResponse> list = data.map((d) => TripResponse.fromJson(d)).toList();
    if(list.any((d) => d.isWaiting)) {
      _buildInviteList(list.where((d) => d.isWaiting).toList());
    } else if(list.any((d) => d.isActive)) {
      _buildActiveTripList(list.where((d) => d.isActive).toList());
    } else {
      _buildTripHistoryList(list.where((d) => d.isClosed || d.isUnfulfilled).toList());
    }
  }

  @override
  void filterActiveTripsByCategory(int index) {
    controller.state.activeTripCategoryFilter.value = index;
    if (index >= 0 && index < commons.length) {
      _filterActiveTripsByCategoryIndex(commons[index].index);
    } else {
      // Handle default case (all items)
      _filterActiveTripsByCategoryIndex(0); // Index 0 represents "All" items
    }
  }

  void _filterActiveTripsByCategoryIndex(int index) {
    String category;

    switch (index) {
      case 1:
        category = commons[1].header.toLowerCase();
        break;
      case 2:
        category = commons[2].header.toLowerCase();
        break;
      case 3:
        category = commons[3].header.toLowerCase();
        break;
      case 4:
        category = commons[4].header.toLowerCase();
        break;
      case 5:
        category = commons[5].header.toLowerCase();
        break;
      default:
        category = ""; // "All" case
        break;
    }

    controller.state.activeTripFilterCategory.value = category;
    if(category.isNotEmpty) {
      controller.state.filteredActiveTrips.value = controller.state.activeTrips.where((invite) {
        return category.toLowerCase() == invite.category.toLowerCase();
      }).toList();
    } else {
      controller.state.filteredActiveTrips.value = controller.state.activeTrips;
    }
  }

  void _filterTripHistoryWithDate(DateTime time) {
    if (time != DateTime(2009)) {
      controller.state.selectedTripHistoryFilterDate.value = time;
      _applyCombinedTripHistoryFilters();
    }
  }

  void _applyCombinedTripHistoryFilters() {
    DateTime filterDate = controller.state.selectedTripHistoryFilterDate.value;
    int shareStatus = controller.state.historyTripShareFilter.value;
    String category = controller.state.tripHistoryFilterCategory.value;

    controller.state.filteredTripHistory.value = controller.state.tripHistory.where((trip) {
      bool matchesDate = filterDate == DateTime(2009) || CommonUtility.isSameDate(trip.updatedAt, filterDate);
      bool matchesShare = shareStatus == 0 ||
          (shareStatus == 1 && trip.shared != null) ||
          (shareStatus == 2 && trip.shared == null);
      bool matchesCategory = category.isEmpty || trip.category.toLowerCase() == category.toLowerCase();
      return matchesShare && matchesCategory && matchesDate;
    }).toList();
  }

  @override
  List<ButtonView> get share => [
    ButtonView(header: "All", index: 0),
    ButtonView(header: "Shared", index: 1),
    ButtonView(header: "Not shared", index: 2),
  ];

  @override
  void filterTripHistoryBySharing(int index) {
    controller.state.historyTripShareFilter.value = index;
    if (index >= 0 && index < share.length) {
      _filterTripHistoryBySharingIndex(share[index].index);
    } else {
      // Handle default case (all items)
      _filterTripHistoryBySharingIndex(0); // Index 0 represents "All" items
    }
  }

  void _filterTripHistoryBySharingIndex(int index) {
    String option;

    switch (index) {
      case 1:
        option = share[1].header.toLowerCase();
        break;
      case 2:
        option = share[2].header.toLowerCase();
        break;
      default:
        option = ""; // "All" case
        break;
    }

    controller.state.selectedTripHistoryShareFilter.value = option;
    _applyCombinedTripHistoryFilters();
  }

  @override
  void filterTripHistoryByCategory(int index) {
    controller.state.activeTripCategoryFilter.value = index;
    if (index >= 0 && index < commons.length) {
      _filterTripHistoryByCategoryIndex(commons[index].index);
    } else {
      // Handle default case (all items)
      _filterTripHistoryByCategoryIndex(0); // Index 0 represents "All" items
    }
  }

  void _filterTripHistoryByCategoryIndex(int index) {
    String category;

    switch (index) {
      case 1:
        category = commons[1].header.toLowerCase();
        break;
      case 2:
        category = commons[2].header.toLowerCase();
        break;
      case 3:
        category = commons[3].header.toLowerCase();
        break;
      case 4:
        category = commons[4].header.toLowerCase();
        break;
      case 5:
        category = commons[5].header.toLowerCase();
        break;
      default:
        category = ""; // "All" case
        break;
    }

    controller.state.tripHistoryFilterCategory.value = category;
    _applyCombinedTripHistoryFilters();
  }

  @override
  void addToActiveTrips(TripResponse response) {
    List<TripResponse> activeTrips = List.from(controller.state.activeTrips);
    int existingIndex = activeTrips.indexWhere((i) => i.id == response.id);

    if (existingIndex != -1) {
      // If the response exists, update the existing response
      activeTrips[existingIndex] = response;
    } else {
      // If the response does not exist, add the new response
      activeTrips.add(response);
    }

    // Sort the list based on `sentAt`
    activeTrips.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    controller.state.activeTrips.value = activeTrips;
    // Apply the current filter
    filterActiveTripsByCategory(controller.state.activeTripCategoryFilter.value);
  }

  @override
  void removeFromActiveTrips(TripResponse response) {
    List<TripResponse> activeTrips = List.from(controller.state.activeTrips); // Create a copy to avoid modifying the controller.state directly
    // Find the index of the existing response
    int existingIndex = activeTrips.indexWhere((i) => i.id == response.id);

    if (existingIndex != -1) {
      // If the response exists, update the existing response
      activeTrips.remove(activeTrips[existingIndex]);
    }

    // Sort the list based on `sentAt`
    activeTrips.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    // Update the controller.state with the new list
    controller.state.activeTrips.value = activeTrips;
    // Apply the current filter
    filterActiveTripsByCategory(controller.state.activeTripCategoryFilter.value);
  }

  @override
  void addToTripHistory(TripResponse response) {
    List<TripResponse> tripHistory = List.from(controller.state.tripHistory);
    int existingIndex = tripHistory.indexWhere((i) => i.id == response.id);

    if (existingIndex != -1) {
      // If the response exists, update the existing response
      tripHistory[existingIndex] = response;
    } else {
      // If the response does not exist, add the new response
      tripHistory.add(response);
    }

    // Sort the list based on `sentAt`
    tripHistory.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    controller.state.tripHistory.value = tripHistory;
    _applyCombinedTripHistoryFilters();
  }

  @override
  void removeFromTripHistory(TripResponse response) {
    List<TripResponse> tripHistory = List.from(controller.state.tripHistory); // Create a copy to avoid modifying the controller.state directly
    // Find the index of the existing response
    int existingIndex = tripHistory.indexWhere((i) => i.id == response.id);

    if (existingIndex != -1) {
      // If the response exists, update the existing response
      tripHistory.remove(tripHistory[existingIndex]);
    }

    // Sort the list based on `sentAt`
    tripHistory.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    // Update the controller.state with the new list
    controller.state.tripHistory.value = tripHistory;
    // Apply the current filter
    _applyCombinedTripHistoryFilters();
  }
}