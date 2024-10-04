import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/state_manager.dart';
import 'package:connectify_flutter/connectify_flutter.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_utils/google_maps_utils.dart';
import 'package:user/library.dart';

class MapViewController extends GetxController with GetTickerProviderStateMixin {
  final String subscriptionEndpoint;
  final Address origin;
  final Address? destination;
  final String distance;

  MapViewController({
    required this.origin,
    this.destination,
    this.subscriptionEndpoint = "",
    this.distance = ""
  });

  final state = MapViewState();

  final Socket _socket = Socket();

  Completer<GoogleMapController> googleMapsController = Completer();
  Animation<double>? animation;

  @override
  void onInit() {
    state.canSubscribe.value = subscriptionEndpoint.isNotEmpty;
    state.origin.value = origin;

    if(destination != null) {
      state.destination.value = destination!;
    }

    _loadStyle();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initializeMap();
    });
    super.onInit();
  }

  LatLng get getDestination => LatLng(state.destination.value.latitude, state.destination.value.longitude);
  LatLng get getOrigin => LatLng(state.origin.value.latitude, state.origin.value.longitude);

  void _loadStyle() async {
    if(Database.preference.isDarkTheme) {
      try {
        String json = await rootBundle.loadString('asset/common/google_map_style.json');
        state.style.value = json;
      } catch (_) { }
    }
  }

  void _initializeMap() async {
    state.isLoadingMap.value = true;
    DirectionsService.init(Keys.googleMapApiKey);

    _addOrUpdateMarker(getOrigin, false);
    _moveMapCamera(getOrigin);

    if(destination != null) {
      _addOrUpdateMarker(getDestination, true);
      await _drawRoute(getOrigin);
      _getTotalDistanceAndTime(getOrigin, getDestination);
    }

    state.isLoadingMap.value = false;
  }

  void _addOrUpdateMarker(LatLng position, bool isDestination, {String? asset}) async {
    final Uint8List markerIcon = await _getBytesFromAsset(
      asset ?? (isDestination ? Media.destination : Media.current),
      isDestination ? 32 : 32,
      isDestination ? 32 : 32
    );
    MarkerId id = MarkerId(isDestination ? "destination" : "current");
    Marker marker = Marker(
        markerId: id,
        position: position,
        rotation: 0,
        visible: true,
        icon: BitmapDescriptor.bytes(markerIcon)
    );

    Map<MarkerId, Marker> markers = Map.from(state.markers);
    if(markers.containsKey(id)) {
      markers[id] = marker;
    } else {
      markers.putIfAbsent(id, () => marker);
    }

    state.markers.value = markers;
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width, int height) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future _moveMapCamera(LatLng target, {double zoom = 16, double bearing = 0}) async {
    CameraPosition newCameraPosition = CameraPosition(target: target, zoom: zoom, bearing: bearing);

    final GoogleMapController controller = await googleMapsController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  Future<void> _drawRoute(LatLng position) async {
    if (state.polyline.isNotEmpty) {
      state.polyline.clear();
      state.polylineCoordinates.clear();
      update();
    }
    if(state.gettingRoute.value) return;

    state.gettingRoute.value = true;

    final directionsService = DirectionsService();

    final request = DirectionsRequest(
      origin: GeoCoord(position.latitude, position.longitude),
      destination: "${getDestination.latitude},${getDestination.longitude}",
      travelMode: TravelMode.driving,
    );

    await directionsService.route(request, (DirectionsResult response, status) {
      log(status);
      if (status == DirectionsStatus.ok && response.routes != null && response.routes!.asMap().values.single.overviewPath != null) {
        for (GeoCoord value in response.routes!.asMap().values.single.overviewPath!) {
          state.polylineCoordinates.add(LatLng(value.latitude, value.longitude));
        }
      }
    });

    PolylineId id = const PolylineId('route');

    Polyline myPolyline = Polyline(
      width: 4,
      visible: true,
      polylineId: id,
      color: CommonColors.darkTheme,
      points: state.polylineCoordinates
    );
    state.polyline.add(myPolyline);
    if(state.canSubscribe.value) {
      await _positionCameraToRoute();
    }

    state.gettingRoute.value = false;
  }

  Future<void> _positionCameraToRoute() async {
    try {
      double minLat = state.polyline.first.points.first.latitude;
      double minLong = state.polyline.first.points.first.longitude;
      double maxLat = state.polyline.first.points.first.latitude;
      double maxLong = state.polyline.first.points.first.longitude;
      for (var poly in state.polyline) {
        for (var point in poly.points) {
          if (point.latitude < minLat) minLat = point.latitude;
          if (point.latitude > maxLat) maxLat = point.latitude;
          if (point.longitude < minLong) minLong = point.longitude;
          if (point.longitude > maxLong) maxLong = point.longitude;
        }
      }
      var c = await googleMapsController.future;
      c.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLong),
          northeast: LatLng(maxLat, maxLong)
        ),
        120
      ));
      // ignore: empty_catches
    } catch (e) {
      log(e, from: "POSITION CAMERA ROUTE");
    }
  }

  void _getTotalDistanceAndTime(LatLng position, LatLng destination) async {
    double distance = 0.0;
    double duration = 0.0;

    List<dynamic> elements = await ConnectifyUtils.getTotalDistanceAndTime(
      originLatitude: position.latitude,
      originLongitude: position.longitude,
      destinationLatitude: destination.latitude,
      destinationLongitude: destination.longitude,
      googleMapApiKey: Keys.googleMapApiKey
    );

    log(elements, from: "GET TOTAL DISTANCE AND TIME");

    if(elements.any((e) => e["status"] == "ZERO_RESULTS")) {
      state.distanceLeft.value = this.distance;
      state.timeLeft.value = "Within close range"; // in minutes
    } else {
      for (var i = 0; i < elements.length; i++) {
        distance = distance + elements[i]['distance']['value'];
        duration = duration + elements[i]['duration']['value'];
      }
      // if (distance < 20) {
      //   state.arrived.value = true;
      // } else {
      //   state.arrived.value = false;
      // }
      state.distanceLeft.value = "${(distance / 1000).toStringAsFixed(2)} km"; // in kilometers
      state.timeLeft.value = "${(duration / 60).toStringAsFixed(2)} minutes"; // in minutes
    }
  }

  @override
  void onReady() {
    if(state.canSubscribe.value) {
      socket.initialize(
        callback: (frame) {
          if(frame.body != null) {
            dynamic data = jsonDecode(frame.body!);
            if(data is Map<String, dynamic>) {
              _workWithSubscription(data);
            }
          }
        },
        subscribeDestination: subscriptionEndpoint
      );
    }
    super.onReady();
  }

  void _workWithSubscription(Map<String, dynamic> data) {
    MapViewResponse response = MapViewResponse.fromJson(data);

    if(response.isNotEmpty) {
      _handleNavigation(response);
    }
  }

  void _handleNavigation(MapViewResponse view) async {
    LatLng newPosition = LatLng(view.latitude, view.longitude);

    _calculateAndUpdateMarker(LatLng(state.origin.value.latitude, state.origin.value.longitude), newPosition);
    state.origin.value = state.origin.value.copyWith(latitude: view.latitude, longitude: view.longitude, place: view.place);
    _moveMapCamera(newPosition, zoom: 15.47, bearing: view.heading);

    _getTotalDistanceAndTime(newPosition, getDestination);
    bool isOnRoute = _getRouteDeviation(newPosition);
    if(!isOnRoute){
      await _drawRoute(newPosition);
    }
  }

  void _calculateAndUpdateMarker(LatLng oldPosition, LatLng newPosition) async {
    AnimationController animationController = AnimationController(duration: const Duration(seconds: 3), vsync: this)
      ..repeat(reverse: false);

    Tween<double> tween = Tween(begin: 0, end: 1);

    animation = tween.animate(animationController)
      ..addListener(() {
        final v = animation!.value;

        double lng = v * newPosition.longitude + (1 - v) * oldPosition.longitude;
        double lat = v * newPosition.latitude + (1 - v) * oldPosition.latitude;
        _addOrUpdateMarker(LatLng(lat, lng), false, asset: Media.drive);
        update();
      });
    animationController.forward();
  }

  bool _getRouteDeviation(LatLng location) {
    List<Point<num>> points = [];
    List<LatLng> list = state.polylineCoordinates.toList();
    for (var i = 0; i < list.length; i++) {
      points.add(Point(list[i].latitude, list[i].longitude));
    }
    return PolyUtils.isLocationOnEdgeTolerance(Point(location.latitude, location.longitude), points, false, 100);
  }

  @override
  void onClose() {
    try {
      if(_socket.isConnected) {
        _socket.disconnect();
      }
    } catch (_) {}

    super.onClose();
  }
}