import 'dart:async';

import 'package:user/library.dart';

class ActivityActiveTripViewMapController {
  TripResponse? _trip;

  final Socket _socket = Socket();
  final StreamController<TripResponse> _tripController = StreamController.broadcast();
  Stream<TripResponse> get activity => _tripController.stream;

  TripResponse get trip => _trip ?? TripResponse.empty();

  void init(TripResponse trip) {
    _trip = trip;
    Future.microtask(() => _tripController.add(trip));

    String endpoint = "/platform/${Database.isUserActive ? Database.auth.id : Database.guest.id}/trip/active/${trip.id}";

    _socket.initialize(
      callback: (frame) {
        if(frame.hasData) {
          TripResponse trip = TripResponse.fromJson(frame.data);
          _trip = trip;

          if(!_tripController.isClosed) {
            _tripController.add(trip);
          }
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