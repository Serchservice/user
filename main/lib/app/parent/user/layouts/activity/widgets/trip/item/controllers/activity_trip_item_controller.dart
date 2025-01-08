import 'dart:async';

import 'package:user/library.dart';

class ActivityTripItemController {
  TripResponse? _trip;

  final Socket _socket = Socket();
  final StreamController<TripResponse> _tripController = StreamController.broadcast();
  Stream<TripResponse> get activity => _tripController.stream;

  TripResponse get trip => _trip ?? TripResponse.empty();

  void init(TripResponse trip) {
    _trip = trip;
    Future.microtask(() => _tripController.add(trip));

    String endpoint = trip.isActive
        ? "/platform/${Database.isUserActive ? Database.auth.id : Database.guest.id}/trip/active/${trip.id}"
        : trip.isWaiting
        ? "/platform/${Database.isUserActive ? Database.auth.id : Database.guest.id}/trip/requested/${trip.id}"
        : "/platform/${Database.isUserActive ? Database.auth.id : Database.guest.id}/trip/history/${trip.id}";

    _socket.initialize(
      callback: (frame) {
        if(frame.hasData) {
          TripResponse trip = TripResponse.fromJson(frame.data);
          _trip = trip;
          _tripController.add(trip);
        }
      },
      endpoint: "/ws:serch",
      subscribeDestination: endpoint
    );
  }

  void dispose() {
    _tripController.close();
  }
}