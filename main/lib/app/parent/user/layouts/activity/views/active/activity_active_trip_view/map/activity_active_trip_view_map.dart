import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActivityActiveTripViewMap extends StatefulWidget {
  final TripResponse trip;
  final Function(TripResponse)? onTap;
  final bool showStatus;
  final bool showShared;
  final bool showTimeline;

  const ActivityActiveTripViewMap({
    super.key,
    required this.trip,
    this.onTap,
    this.showStatus = true,
    this.showShared = false,
    this.showTimeline = false
  });

  @override
  State<ActivityActiveTripViewMap> createState() => _ActivityActiveTripViewMapState();
}

class _ActivityActiveTripViewMapState extends State<ActivityActiveTripViewMap> {
  final ActivityActiveTripViewMapController _controller = ActivityActiveTripViewMapController();

  @override
  void initState() {
    _controller.init(widget.trip);
    setState(() {});

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TripResponse>(
      stream: _controller.activity,
      builder: (_, snapshot) {
        TripResponse trip = widget.trip;
        if(snapshot.hasData && snapshot.data != null) {
          trip = snapshot.data!;
        }

        if(trip.shared != null && trip.shared!.location.isNotEmpty) {
          return MapView(
            isTop: true,
            origin: trip.toAddress(),
            destination: trip.shared!.location.toAddress(),
            height: Get.height,
            subscription: "/platform/location/${trip.id}/${Database.auth.id}"
          );
        } else if(trip.location.isNotEmpty) {
          return MapView(
            isTop: true,
            origin: trip.toAddress(),
            destination: trip.location.toAddress(),
            height: Get.height,
            subscription: "/platform/location/${trip.id}/${Database.auth.id}"
          );
        }

        return MapView(isTop: true, origin: widget.trip.toAddress(), height: Get.height);
      },
    );
  }
}

extension on TripResponse {
  Address toAddress() {
    return Address(
      id: id,
      latitude: latitude,
      longitude: longitude,
      place: address,
    );
  }
}

extension on MapViewResponse {
  Address toAddress() {
    return Address(
      id: "",
      latitude: latitude,
      longitude: longitude,
      place: place,
    );
  }
}