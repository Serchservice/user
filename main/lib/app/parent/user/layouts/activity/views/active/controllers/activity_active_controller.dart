import 'package:user/library.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ActivityActiveController extends GetxController {
  ActivityActiveController();
  static ActivityActiveController get data => Get.find<ActivityActiveController>();

  final ActivityActiveState state = ActivityActiveState();

  final ConnectService _connect = Connect(showError: false, useToken: Database.isUserActive);
  final Socket _scheduleSocket = Socket();
  final Socket _tripListSocket = Socket();
  final Socket _tripSocket = Socket();

  final _pageSize = 20;
  final _commons = ActivityController.data.filterButtons;

  final PagingController<int, TripResponse> tripController = PagingController(firstPageKey: 0);
  final PagingController<int, Schedule> scheduleController = PagingController(firstPageKey: 0);

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
    String pagination = "page=$pageKey&size=$_pageSize";
    String url = Database.isUserActive
        ? "/trip/history/active?$pagination"
        : "/trip/history/active?guest=${Database.guest.id}&link=${Database.preference.active}&$pagination";

    var response = await _connect.get(endpoint: url);

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

      _filterTrips(state.tripFilterIndex.value);
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
      var response = await _connect.get(endpoint: "/schedule/history/active?page=$pageKey&size=$_pageSize");

      if(response.isOk) {
        List<dynamic> result = response.data;
        List<Schedule> schedules = result.map((e) => Schedule.fromJson(e)).toList();

        if(pageKey == 0) {
          state.schedules.value = schedules;
        } else {
          _updateSchedules(schedules);
        }

        final isLastPage = schedules.length < _pageSize;
        if(isLastPage) {
          scheduleController.appendLastPage(schedules);
        } else {
          scheduleController.appendPage(schedules, CommonUtility.increment(pageKey));
        }

        _filterSchedules(state.scheduleFilterIndex.value);
      } else {
        scheduleController.error = response.message;
      }
    }
  }

  void _updateSchedules(List<Schedule> schedules) {
    Set<String> existingIds = state.schedules.map((trip) => trip.id).toSet();
    List<Schedule> tripsToAdd = schedules.where((trip) => !existingIds.contains(trip.id)).toList();

    List<Schedule> updated = List.from(state.schedules);
    for (var newTrip in schedules) {
      final existingIndex = updated.indexWhere((trip) => trip.id == newTrip.id);
      if (existingIndex != -1) {
        updated[existingIndex] = newTrip;
      }
    }

    List<Schedule> allSchedules = updated..addAll(tripsToAdd);
    state.schedules.value = allSchedules;
  }

  String filterRoute(String current) => "/activity/filter?tab=active&current=$current";

  void filter(int index) {
    state.filterIndex.value = index;
  }

  void filterTrips(int index) {
    state.tripFilterIndex.value = index;

    if (index >= 0 && index < _commons.length) {
      _filterTrips(_commons[index].index);
    } else {
      _filterTrips(0);
    }
  }

  void _filterTrips(int index) {
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

    state.tripFilter.value = category;
    if(category.isNotEmpty) {
      List<TripResponse> existing = List.from(state.trips);
      List<TripResponse> result = existing.where((a) {
        return a.category.toLowerCase().replaceAll("_", " ") == category.toLowerCase();
      }).toList();

      tripController.itemList = result;
    } else {
      tripController.itemList = state.trips;
    }
  }

  void filterSchedules(int index) {
    state.scheduleFilterIndex.value = index;

    if (index >= 0 && index < _commons.length) {
      _filterSchedules(_commons[index].index);
    } else {
      _filterSchedules(0);
    }
  }

  void _filterSchedules(int index) {
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

    state.scheduleFilter.value = category;
    if(category.isNotEmpty) {
      List<Schedule> existing = List.from(state.schedules);
      List<Schedule> result = existing.where((a) {
        return a.category.toLowerCase().replaceAll("_", " ") == category.toLowerCase();
      }).toList();

      scheduleController.itemList = result;
    } else {
      scheduleController.itemList = state.schedules;
    }
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

    _filterTrips(state.tripFilterIndex.value);
  }

  @override
  void onReady() {
    if(Database.isUserActive) {
      _scheduleSocket.initialize(
        callback: (frame) {
          if (frame.hasData) {
            List<dynamic> result = frame.data;
            List<Schedule> schedules = result.map((e) => Schedule.fromJson(e)).toList();

            _resetSchedules(schedules);
          }
        },
        endpoint: "/ws:serch",
        subscribeDestination: "/platform/schedule/active/${Database.auth.id}"
      );
    }

    String user = Database.isUserActive ? Database.auth.id : Database.guest.id;

    _tripListSocket.initialize(
      callback: (frame) {
        if (frame.hasData) {
          List<dynamic> result = frame.data;
          List<TripResponse> trips = result.map((e) => TripResponse.fromJson(e)).toList();

          updateTrips(trips);
        }
      },
      endpoint: "/ws:serch",
      subscribeDestination: "/platform/$user/trip/active/history"
    );

    _tripSocket.initialize(
      callback: (frame) {
        if (frame.hasData) {
          TripResponse response = TripResponse.fromJson(frame.data);

          addTrip(response);
        }
      },
      endpoint: "/ws:serch",
      subscribeDestination: "/platform/$user/trip/active"
    );

    super.onReady();
  }

  void _resetSchedules(List<Schedule> schedules) {
    if(schedules.isNotEmpty) {
      state.schedules.value = schedules;

      scheduleController.itemList = schedules;
      scheduleController.nextPageKey = 1;

      _filterSchedules(state.scheduleFilterIndex.value);
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
    tripController.dispose();
    scheduleController.dispose();
    _scheduleSocket.disconnect();
    _tripSocket.disconnect();
    _tripListSocket.disconnect();

    super.onClose();
  }
}