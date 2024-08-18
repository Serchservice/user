import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:user/library.dart';

class NavigationOptionSheetController extends GetxController {
  final SearchShopResponse shop;
  NavigationOptionSheetController({required this.shop});

  final state = NavigationOptionSheetState();

  final LocationService _location = LocationImplementation();
  final ConnectService _connect = Connect();

  String get info => state.selected.value == 0 ? "in app navigation" : "google map navigation";

  List<ButtonView> options(BuildContext context) => [
    ButtonView(
      header: state.isCreatingRoute.value
        ? "Preparing route for $info"
        : "Navigate with in app - Serch",
      icon: FontAwesomeIcons.map,
      color: Theme.of(context).primaryColor,
      index: 0,
      path: ""
    ),
    ButtonView(
      header: state.isCreatingRoute.value
          ? "Preparing route for $info"
          : "Navigate with Google map",
      icon: FontAwesomeIcons.google,
      color: Theme.of(context).primaryColor,
      index: 1,
      path: ""
    ),
  ];

  void act(ButtonView view) {
    if(state.isCreatingRoute.value) {
      return;
    } else {
      state.selected.value = view.index;

      if(view.index == 0) {
        _driveInApp();
      } else {
        _driveWithGoogle();
      }
    }
  }

  void _driveInApp() async {
    state.isCreatingRoute.value = true;
    _location.getAddress(
      onSuccess: (address, position) async {
        MapBoxOptions options = MapBoxNavigation.instance.getDefaultOptions();
        options.initialLatitude = position.latitude;
        options.initialLongitude = position.longitude;
        options.mode = MapBoxNavigationMode.driving;
        options.mapStyleUrlDay = "";
        options.mapStyleUrlNight = "";

        MapBoxNavigation.instance.registerRouteEventListener(_onRouteEvent);

        final origin = WayPoint(
            name: address.place,
            latitude: position.latitude,
            longitude: position.longitude
        );
        final destination = WayPoint(
          name: shop.shop.address,
          latitude: shop.shop.latitude,
          longitude: shop.shop.longitude,
        );

        var wayPoints = <WayPoint>[];
        wayPoints.add(origin);
        wayPoints.add(destination);

        Navigate.till(ModalRoute.withName(HomeLayout.route));

        await MapBoxNavigation.instance.startNavigation(wayPoints: wayPoints, options: options);
        _drive(shop.shop.id, address);
      },
      onError: (error) {
        notify.error(message: error);
      });
  }

  void _drive(String shopId, Address address) async {
    await _connect.post(endpoint: "/shop/drive", body: {
      "shop_id": shopId,
      "address": address.place,
      "place_id": address.id,
      "latitude": address.latitude,
      "longitude": address.longitude
    });
  }

  Future<void> _onRouteEvent(RouteEvent event) async {
    log(event.eventType);

    if(event.data is RouteProgressEvent) {
      RouteProgressEvent progressEvent = event.data as RouteProgressEvent;
      log(progressEvent.currentLeg?.steps?.first.name, from: "EVENT MAP");
    } else {
      log(event.data);
    }

    switch (event.eventType) {
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        state.isCreatingRoute.value = false;
        break;
      case MapBoxEvent.on_arrival:
        _disposeResources();
        break;
      default:
        break;
    }
  }

  void _disposeResources() async {
    await Future.delayed(const Duration(seconds: 3));
    await MapBoxNavigation.instance.finishNavigation();
  }

  void _driveWithGoogle() async {
    state.isCreatingRoute.value = true;
    _location.getAddress(
      onSuccess: (address, position) async {
        String destination = "${shop.shop.latitude},${shop.shop.longitude}";
        String origin = "${position.latitude},${position.longitude}";

        String url = "https://www.google.com/map/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving&dir_action=navigate";
        _drive(shop.shop.id, address);
        Navigate.till(ModalRoute.withName(HomeLayout.route));
        RouteNavigator.openLink(url: url);

        state.isCreatingRoute.value = false;
      },
      onError: (error) {
        notify.error(message: error);
      });
  }
}