import 'dart:convert';

import 'package:get/get.dart';
import 'package:user/library.dart';

class ActivityRequestedTripViewController extends GetxController {
  final TripResponse trip;
  ActivityRequestedTripViewController({required this.trip});

  final state = ActivityRequestedTripViewState();

  final Socket _socket = Socket();

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
          TripResponse trip = TripResponse.fromJson(jsonDecode(frame.body!));
          state.trip.value = trip;

          if(trip.isActive) {
            closeInvitedAndOpenActive(trip);
          } else {
            ActivityRequestedController.data.addTrip(trip);
          }
        }
      },
      endpoint: "/ws:serch",
      subscribeDestination: "/platform/${Database.isUserActive ? Database.auth.id : Database.guest.id}/trip/requested/${trip.id}"
    );

    super.onReady();
  }

  void closeInvitedAndOpenActive(TripResponse trip) {
    ActivityRequestedController.data.tripController.refresh();
    Navigate.back();

    ActivityActiveController.data.addTrip(trip);
    ActivityActiveTripView.open(trip);
    EventController.data.addTrip(trip);
  }

  @override
  void onClose() {
    _socket.disconnect();
    _socket.disconnect();

    super.onClose();
  }

  void removeQuotation(QuotationResponse quotation) {
    List<QuotationResponse> quotations = List.from(trip.quotations);
    // Find the index of the existing response
    int existingIndex = quotations.indexWhere((i) => i.id == quotation.id);

    if (existingIndex != -1) {
      // If the response exists, update the existing response
      quotations.remove(quotations[existingIndex]);
    }

    // Update the trip with the new list
    trip.copyWith(quotations: quotations);
    state.trip.value = trip;
    ActivityRequestedController.data.addTrip(trip);
  }

  void removeTrip(TripResponse response) {
    ActivityRequestedController.data.tripController.refresh();
    ActivityActiveController.data.addTrip(response);
    Navigate.back();
    ActivityActiveTripView.open(response);
  }

  void updateTrip(TripResponse response) {
    ActivityRequestedController.data.addTrip(response);
    state.trip.value = response;
  }

  void cancelTrip(List<TripResponse> trips, bool goBack) async {
    if(trips.isNotEmpty) {
      ActivityHistoryController.data.tripController.refresh();
    }

    ActivityRequestedController.data.tripController.refresh();
    if(goBack) {
      Navigate.back();
    }
  }
}