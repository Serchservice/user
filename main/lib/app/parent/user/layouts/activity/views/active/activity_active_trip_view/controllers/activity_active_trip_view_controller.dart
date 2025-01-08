import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActivityActiveTripViewController extends GetxController {
  final TripResponse trip;
  ActivityActiveTripViewController({required this.trip});

  final state = ActivityActiveTripViewState();

  final Socket _socket = Socket();
  final ConnectService _connect = Connect(useToken: Database.isUserActive);

  final TextEditingController authController = TextEditingController();
  final FocusNode authFocusNode = FocusNode();

  @override
  void onInit() {
    state.trip.value = trip;

    super.onInit();
  }

  @override
  void onReady() {
    _socket.initialize(
      callback: (frame) {
        if(frame.body != null) {
          update();
          refresh();
          updateTrip(TripResponse.fromJson(jsonDecode(frame.body!)));
        }
      },
      endpoint: "/ws:serch",
      subscribeDestination: "/platform/${Database.isUserActive ? Database.auth.id : Database.guest.id}/trip/active/${trip.id}"
    );

    super.onReady();
  }

  void updateTrip(TripResponse trip) {
    state.trip.value = trip;
    state.isSharedOnTheWay.value = trip.shared != null
        && trip.shared!.timelines.any((t) => t.isOnTheWay && !t.isOver);
    state.isProviderOnTheWay.value = trip.timelines.any((t) => t.isOnTheWay && t.isOver);

    if(trip.isClosed) {
      Navigate.back();
      _closeTrip();
    } else {
      ActivityActiveController.data.addTrip(trip);
    }
  }

  void _closeTrip() {
    RatingSheet.open(onSuccess: (string, rating) => Navigate.back(), trip: state.trip.value);
    ActivityActiveController.data.tripController.refresh();
    HomeController.data.refreshData();
    EventController.data.removeTripById(state.trip.value.id);
    Get.delete<ActivityActiveTripViewController>();
  }

  void cancel(List<TripResponse> trips, bool goBack) {
    if(trips.isNotEmpty) {
      ActivityHistoryController.data.updateTrips(trips);
      ActivityActiveController.data.tripController.refresh();
    }

    if(goBack) {
      Navigate.back();
    }
  }

  void verifyAuth(String code) async {
    state.authToken.value = code;
    state.isVerifying.value = true;

    Map<String, dynamic> data = {"code": state.authToken.value, "trip": trip.id};
    if(Database.isGuestActive) {
      data.putIfAbsent("guest", () => Database.guest.id);
    }

    var response = await _connect.patch(endpoint: "/trip/auth", body: data);

    state.isVerifying.value = false;
    if(response.isSuccessful) {
      TripResponse trip = TripResponse.fromJson(response.data);
      state.trip.value = trip;
      ActivityActiveController.data.addTrip(trip);
    } else {
      notify.error(message: response.message);
    }
  }

  void grantAccess() async {
    state.isGrantingAccess.value = true;

    String endpoint = "/trip/shared/access?id=${trip.id}";
    String url = Database.isUserActive ? endpoint : "$endpoint&guest=${Database.guest.id}";

    var response = await _connect.patch(endpoint: url);

    state.isGrantingAccess.value = false;
    if(response.isSuccessful) {
      TripResponse trip = TripResponse.fromJson(response.data);
      state.trip.value = trip;
      ActivityActiveController.data.addTrip(trip);
    } else {
      notify.error(message: response.message);
    }
  }

  void denyAccess() async {
    state.isDenyingAccess.value = true;

    String endpoint = "/trip/shared/access?id=${trip.id}";
    String url = Database.isUserActive ? endpoint : "$endpoint&guest=${Database.guest.id}";

    var response = await _connect.patch(endpoint: url);

    state.isDenyingAccess.value = false;
    if(response.isSuccessful) {
      TripResponse trip = TripResponse.fromJson(response.data);
      state.trip.value = trip;
      ActivityActiveController.data.addTrip(trip);
    } else {
      notify.error(message: response.message);
    }
  }

  void end() async {
    state.isEnding.value = true;

    Map<String, dynamic> data = {"trip": trip.id};
    if(Database.isGuestActive) {
      data.putIfAbsent("guest", () => Database.guest.id);
      data.putIfAbsent("link_id", () => Database.preference.active);
    }

    var response = await _connect.patch(endpoint: "/trip/end", body: data);

    state.isEnding.value = false;
    if(response.isSuccessful) {
      List<dynamic> data = response.data;
      List<TripResponse> trips = data.map((t) => TripResponse.fromJson(t)).toList();
      cancel(trips, true);

      _closeTrip();
    } else {
      notify.error(message: response.message);
    }
  }

  void verifySharedAuth(String code) async {
    state.authToken.value = code;
    state.isVerifying.value = true;

    Map<String, dynamic> data = {"code": state.authToken.value, "trip": trip.id};
    if(Database.isGuestActive) {
      data.putIfAbsent("guest", () => Database.guest.id);
    }

    var response = await _connect.patch(endpoint: "/trip/shared/auth", body: data);

    state.isVerifying.value = false;
    if(response.isSuccessful) {
      TripResponse trip = TripResponse.fromJson(response.data);
      state.trip.value = trip;
      ActivityActiveController.data.addTrip(trip);
    } else {
      notify.error(message: response.message);
    }
  }

  @override
  void onClose() {
    _socket.disconnect();
    authController.dispose();
    authFocusNode.dispose();

    super.onClose();
  }
}