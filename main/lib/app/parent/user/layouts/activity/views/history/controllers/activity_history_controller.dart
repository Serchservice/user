import 'package:intl/intl.dart';
import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ActivityHistoryController extends GetxController {
  ActivityHistoryController();
  static ActivityHistoryController get data => Get.find<ActivityHistoryController>();

  final ActivityHistoryState state = ActivityHistoryState();

  final ConnectService _connect = Connect(showError: false, useToken: Database.isUserActive);
  final Socket _scheduleSocket = Socket();
  final Socket _tripListSocket = Socket();

  final _pageSize = 20;
  final _commons = ActivityController.data.filterButtons;
  final _shared = ActivityController.data.sharedButtons;

  final PagingController<int, TripResponse> tripController = PagingController(firstPageKey: 0);
  final PagingController<int, ScheduleGroup> scheduleController = PagingController(firstPageKey: 0);

  List<ButtonView> get scheduleFilterButtons => [
    ButtonView(header: "All", index: 0),
    ButtonView(header: "Cancelled", index: 1),
    ButtonView(header: "Attended", index: 2),
    ButtonView(header: "Declined", index: 3),
    ButtonView(header: "Closed", index: 4),
    ButtonView(header: "No trip", index: 5),
  ];

  @override
  void onInit() {
    tripController.addPageRequestListener((pageKey) {
      _fetchTrips(pageKey);
    });

    scheduleController.addPageRequestListener((pageKey) {
      _fetchSchedules(pageKey);
    });

    super.onInit();
  }

  Future<void> _fetchTrips(int pageKey) async {
    String filters = "";
    if(state.tripFilterCategory.isNotEmpty) {
      filters = "$filters&category=${state.tripFilterCategory.value.toUpperCase()}";
    }
    if(state.tripFilterDate.value != DateTime(2009)) {
      String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(state.tripFilterDate.value.toUtc());
      filters = "$filters&date_time=$formattedDate";
    }
    if(state.tripFilterSharingIndex.value != 0) {
      if(state.tripFilterSharingIndex.value == 1) {
        filters = "$filters&shared=${true}";
      } else {
        filters = "$filters&shared=${false}";
      }
    }
    if(Database.isGuestActive) {
      filters = "$filters&guest=${Database.guest.id}&link=${Database.preference.active}";
    }

    String endpoint = "/trip/history?page=$pageKey&size=$_pageSize$filters";
    var response = await _connect.get(endpoint: endpoint);

    if(response.isOk) {
      List<dynamic> result = response.data;
      List<TripResponse> trips = result.map((data) => TripResponse.fromJson(data)).toList();

      if(pageKey == 0) {
        state.trips.value = trips;
      } else {
        _updateTrips(trips);
      }

      final isLastPage = trips.length < _pageSize;
      if(isLastPage) {
        tripController.appendLastPage(trips);
      } else {
        tripController.appendPage(trips, CommonUtility.increment(pageKey));
      }

      // _applyCombinedTripFilters();
    } else {
      tripController.error = response.message;
    }
  }

  void _updateTrips(List<TripResponse> trips) {
    Set<String> existingIds = state.trips.map((trip) => trip.id).toSet();
    List<TripResponse> tripsToAdd = trips.where((trip) => !existingIds.contains(trip.id)).toList();

    List<TripResponse> updated = List.from(state.trips);
    for (var newTrip in trips) {
      final existingIndex = updated.indexWhere((trip) => trip.id == newTrip.id);
      if (existingIndex != -1) {
        updated[existingIndex] = newTrip;
      }
    }

    List<TripResponse> allTrips = updated..addAll(tripsToAdd);
    state.trips.value = allTrips;
  }

  Future<void> _fetchSchedules(int pageKey) async {
    if(Database.isUserActive) {
      String filters = "";
      if(state.scheduleFilterCategory.isNotEmpty) {
        filters = "$filters&category=${state.scheduleFilterCategory.value.toUpperCase()}";
      }
      if(state.scheduleFilterStatus.isNotEmpty) {
        filters = "$filters&status=${state.scheduleFilterStatus.value.toUpperCase()}";
      }
      if(state.scheduleFilterDate.value != DateTime(2009)) {
        String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(state.scheduleFilterDate.value.toUtc());
        filters = "$filters&date_time=$formattedDate";
      }

      String endpoint = "/schedule/history?page=$pageKey&size=$_pageSize$filters";
      var response = await _connect.get(endpoint: endpoint);

      if(response.isOk) {
        List<dynamic> result = response.data;
        List<ScheduleGroup> schedules = result.map((e) => ScheduleGroup.fromJson(e)).toList();

        if(pageKey == 0) {
          state.schedules.value = schedules;
        } else {
          _updateSchedules(schedules);
        }

        if(scheduleController.itemList != null) {
          List<ScheduleGroup> existingList = scheduleController.itemList!;
          for (var group in existingList) {
            int index = schedules.indexWhere((group) => group.label == group.label);
            if (index != -1) {
              int groupIndex = existingList.indexOf(group);
              if(groupIndex != -1) {
                group.schedules.addAll(schedules[index].schedules);
                scheduleController.itemList![groupIndex] = group;

                schedules.removeAt(index);
              }
            }
          }
        }

        final isLastPage = schedules.length < _pageSize;
        if(isLastPage) {
          scheduleController.appendLastPage(schedules);
        } else {
          scheduleController.appendPage(schedules, CommonUtility.increment(pageKey));
        }

        _applyCombinedScheduleFilters();
      } else {
        scheduleController.error = response.message;
      }
    }
  }

  void _updateSchedules(List<ScheduleGroup> schedules) {
    List<ScheduleGroup> existing = List.from(state.schedules);
    existing.addAll(schedules);
    state.schedules.value = existing;

    List<ScheduleGroup> existingGroups = List.from(state.schedules);
    final groups = _mergeGroups(existingGroups, schedules);

    List<ScheduleGroup> scheduleGroups = groups.values.toList();

    scheduleGroups.sort((a, b) => a.time.compareTo(b.time));
    state.schedules.value = scheduleGroups;
  }

  Map<String, ScheduleGroup> _mergeGroups(List<ScheduleGroup> existingGroups, List<ScheduleGroup> newGroups) {
    Map<String, ScheduleGroup> groupMap = {
      for (var group in existingGroups) group.label: group
    };

    return newGroups.fold<Map<String, ScheduleGroup>>(groupMap, (map, newGroup) {
      final existingGroup = map[newGroup.label];

      if (existingGroup != null) {
        Map<String, Schedule> scheduleMap = {
          for (var schedule in existingGroup.schedules) schedule.id: schedule
        };

        List<Schedule> mergedSchedules = newGroup.schedules.fold<Map<String, Schedule>>(scheduleMap, (map, schedule) {
          Schedule? existingSchedule = map[schedule.id];

          if(existingSchedule != null) {
            map[schedule.id] = schedule;
          } else {
            map[schedule.id] = schedule;
          }

          return map;
        }).values.toList();
        mergedSchedules.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        map[newGroup.label] = existingGroup.copyWith(schedules: mergedSchedules);
      } else {
        map[newGroup.label] = newGroup;
      }

      return map;
    });
  }

  String filterRoute(String current) => "/activity/filter?tab=history&current=$current";

  void filter(int index) {
    state.filterIndex.value = index;
  }

  void filterTripsByCategory(int index) {
    state.tripFilterCategoryIndex.value = index;

    if (index >= 0 && index < _commons.length) {
      _filterTripsByCategory(_commons[index].index);
    } else {
      _filterTripsByCategory(0);
    }
  }

  void _filterTripsByCategory(int index) {
    String category;

    switch (index) {
      case 1:
        category = _commons[1].body.toLowerCase();
        break;
      case 2:
        category = _commons[2].body.toLowerCase();
        break;
      case 3:
        category = _commons[3].body.toLowerCase();
        break;
      case 4:
        category = _commons[4].body.toLowerCase();
        break;
      case 5:
        category = _commons[5].body.toLowerCase();
        break;
      default:
        category = "";
        break;
    }

    state.tripFilterCategory.value = category;
    _applyCombinedTripFilters();
  }

  void filterTripsBySharing(int index) {
    if (index >= 0 && index < _shared.length) {
      state.tripFilterSharingIndex.value = index;
    } else {
      state.tripFilterSharingIndex.value = 0;
    }

    _applyCombinedTripFilters();
  }

  void filterScheduleByCategory(int index) {
    state.scheduleFilterCategoryIndex.value = index;

    if (index >= 0 && index < _commons.length) {
      _filterScheduleByCategory(_commons[index].index);
    } else {
      _filterScheduleByCategory(0);
    }
  }

  void _filterScheduleByCategory(int index) {
    String category;

    switch (index) {
      case 1:
        category = _commons[1].header.toLowerCase();
        break;
      case 2:
        category = _commons[2].header.toLowerCase();
        break;
      case 3:
        category = _commons[3].header.toLowerCase();
        break;
      case 4:
        category = _commons[4].header.toLowerCase();
        break;
      case 5:
        category = _commons[5].header.toLowerCase();
        break;
      default:
        category = "";
        break;
    }

    state.scheduleFilterCategory.value = category;
    _applyCombinedScheduleFilters();
  }

  void filterScheduleByStatus(int index) {
    state.scheduleFilterStatusIndex.value = index;

    if (index >= 0 && index < _shared.length) {
      _filterScheduleByStatus(_shared[index].index);
    } else {
      _filterScheduleByStatus(0);
    }
  }

  void _filterScheduleByStatus(int index) {
    String status;

    switch (index) {
      case 1:
        status = scheduleFilterButtons[1].header.toLowerCase();
        break;
      case 2:
        status = scheduleFilterButtons[2].header.toLowerCase();
        break;
      case 3:
        status = scheduleFilterButtons[3].header.toLowerCase();
        break;
      case 4:
        status = scheduleFilterButtons[4].header.toLowerCase();
        break;
      case 5:
        status = "unattended";
        break;
      default:
        status = "";
        break;
    }

    state.scheduleFilterStatus.value = status;
    _applyCombinedScheduleFilters();
  }

  void clearFilter(bool isSchedule) {
    if (isSchedule) {
      state.scheduleFilterDate.value = DateTime(2009);
      state.scheduleFilterStatus.value = "";
      state.scheduleFilterStatusIndex.value = 0;
      state.scheduleFilterCategory.value = "";
      state.scheduleFilterCategoryIndex.value = 0;

      _applyCombinedScheduleFilters();
    } else {
      state.tripFilterDate.value = DateTime(2009);
      state.tripFilterSharingIndex.value = 0;
      state.tripFilterCategory.value = "";
      state.tripFilterCategoryIndex.value = 0;

      _applyCombinedTripFilters();
    }
  }

  void pickDate({required bool isSchedule, required BuildContext context}) async {
    DateTime? result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime.now(),
      routeSettings: RouteSettings(name: isSchedule ? filterRoute("schedule_date") : filterRoute("trip_date")),
    );

    if(result != null) {
      if(isSchedule && (result != DateTime(2009))) {
        state.scheduleFilterDate.value = result;

        _applyCombinedScheduleFilters();
      } else if(!isSchedule && (result != DateTime(2009))){
        state.tripFilterDate.value = result;

        _applyCombinedTripFilters();
      }
    }
  }

  void _applyCombinedTripFilters() {
    DateTime filterDate = state.tripFilterDate.value;
    int shareStatus = state.tripFilterSharingIndex.value;

    List<TripResponse> existing = List.from(state.trips);
    List<TripResponse> result = existing.where((trip) {
      bool matchesDate = filterDate == DateTime(2009) || CommonUtility.isSameDate(trip.updatedAt, filterDate);
      bool matchesShare = shareStatus == 0 ||
          (shareStatus == 1 && trip.shared != null) ||
          (shareStatus == 2 && trip.shared == null);
      return matchesShare && matchesDate;
    }).toList();

    tripController.itemList = result;
  }

  void _applyCombinedScheduleFilters() {
    DateTime filterDate = state.scheduleFilterDate.value;
    String filterStatus = state.scheduleFilterStatus.value;

    List<ScheduleGroup> existing = List.from(state.schedules);
    List<ScheduleGroup> result = existing.map((group) {
      bool matchesDate = filterDate == DateTime(2009) || CommonUtility.isSameDate(group.time, filterDate);

      if (matchesDate) {
        List<Schedule> filteredSchedules = group.schedules.where((schedule) {
          return filterStatus.isEmpty || schedule.status.toLowerCase() == filterStatus.toLowerCase();
        }).toList();

        if (filteredSchedules.isNotEmpty) {
          return group.copyWith(schedules: filteredSchedules);
        }
      }

      return group.copyWith(schedules: []);
    }).where((group) => group.schedules.isNotEmpty).toList();

    scheduleController.itemList = result;
  }

  void addTrip(TripResponse trip) {
    List<TripResponse> trips = List.from(state.trips);
    int existingIndex = trips.indexWhere((i) => i.id == trip.id);

    if (existingIndex != -1) {
      trips[existingIndex] = trip;
    } else {
      trips.add(trip);
    }

    trips.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    _updateTrips(trips);

    _applyCombinedTripFilters();
  }

  @override
  void onReady() {
    if(Database.isUserActive) {
      _scheduleSocket.initialize(
        callback: (frame) {
          if (frame.hasData) {
            List<dynamic> result = frame.data;
            List<ScheduleGroup> schedules = result.map((e) => ScheduleGroup.fromJson(e)).toList();

            _resetSchedules(schedules);
          }
        },
        endpoint: "/ws:serch",
        subscribeDestination: "/platform/schedule/history/${Database.auth.id}"
      );
    }

    _tripListSocket.initialize(
      callback: (frame) {
        if (frame.hasData) {
          List<dynamic> result = frame.data;
          List<TripResponse> trips = result.map((e) => TripResponse.fromJson(e)).toList();

          updateTrips(trips);
        }
      },
      endpoint: "/ws:serch",
      subscribeDestination: "/platform/${Database.isUserActive ? Database.auth.id : Database.guest.id}/trip/history"
    );

    super.onReady();
  }

  void _resetSchedules(List<ScheduleGroup> schedules) {
    if(schedules.isNotEmpty) {
      state.schedules.value = schedules;

      scheduleController.itemList = schedules;
      scheduleController.nextPageKey = 1;

      _applyCombinedScheduleFilters();
    }
  }

  void updateTrips(List<TripResponse> trips) {
    if(trips.isNotEmpty) {
      state.trips.value = trips;

      tripController.itemList = trips;
      tripController.nextPageKey = 1;
    }
  }

  @override
  void onClose() {
    _tripListSocket.disconnect();
    _scheduleSocket.disconnect();
    tripController.dispose();
    scheduleController.dispose();

    super.onClose();
  }
}