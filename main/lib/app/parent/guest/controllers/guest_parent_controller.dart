import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestParentController extends GetxController {
  GuestParentController();

  final GuestParentState state = GuestParentState();

  static GuestParentController get data => Get.find<GuestParentController>();

  static void bind() {
    if(!Get.isRegistered<GuestHomeController>()) {
      Get.put<GuestHomeController>(GuestHomeController());
    }

    if(!Get.isRegistered<EventController>()) {
      Get.put<EventController>(EventController());
    }

    if(!Get.isRegistered<ActivityController>()) {
      Get.put<ActivityController>(ActivityController());
    }

    if(!Get.isRegistered<ActivityActiveController>()) {
      Get.put<ActivityActiveController>(ActivityActiveController());
    }

    if(!Get.isRegistered<ActivityHistoryController>()) {
      Get.put<ActivityHistoryController>(ActivityHistoryController());
    }

    if(!Get.isRegistered<ActivityRequestedController>()) {
      Get.put<ActivityRequestedController>(ActivityRequestedController());
    }

    if(!Get.isRegistered<GuestCentreController>()) {
      Get.put<GuestCentreController>(GuestCentreController());
    }

    try {
      if(!GuestParentController.data.initialized) {
        Get.lazyPut<GuestParentController>(() => GuestParentController());
      }
    } catch (_) {
      Get.lazyPut<GuestParentController>(() => GuestParentController());
    }
  }

  final ConnectService _connect = Connect();
  final Socket _socket = Socket();

  final AppService _appService = AppImplementation();
  final AuthValidatorService _apiService = AuthValidator();
  final FirebaseMessagingService _firebaseService = FirebaseMessagingImplementation();
  final LocationService _locationService = LocationImplementation();

  List<DynamicIconButtonView> tabs = [
    DynamicIconButtonView(
      icon: Icons.dashboard_outlined,
      active: Icons.dashboard_rounded,
      title: "Home",
      index: 0
    ),
    DynamicIconButtonView(
      icon: Icons.connect_without_contact_rounded,
      active: Icons.connect_without_contact_rounded,
      title: "Activity",
      index: 1,
    ),
    DynamicIconButtonView(
      icon: Icons.account_circle_outlined,
      active: Icons.account_circle_rounded,
      title: "Centre",
      index: 2
    ),
  ];

  final params = Get.parameters;

  @override
  void onInit() {
    if(params.containsKey("view")) {
      if(params["view"] != null && (params["view"]!.toHomeType()) == HomeType.home) {
        state.routeIndex.value = 0;
      } else if(params["view"] != null && (params["view"]!.toHomeType()) == HomeType.connect) {
        state.routeIndex.value = 1;
      } else if(params["view"] != null && (params["view"]!.toHomeType()) == HomeType.activity) {
        state.routeIndex.value = 2;
      } else if(params["view"] != null && (params["view"]!.toHomeType()) == HomeType.centre) {
        state.routeIndex.value = 3;
      }
    }

    launchDevice();
    _apiService.fetchAccounts();
    _locationService.getAddress(onSuccess: (address, position) => Database.saveAddress(address), onError: (error) {});

    super.onInit();
  }

  @override
  void onReady() {
    AnalyticsEngine.logOpen();

    _appService.checkUpdate();
    _firebaseService.foreground();
    _sendServerUpdate();

    _socket.initialize(
      callback: (frame) {
        if (frame.body != null) {
          _listener(jsonDecode(frame.body!));
        }
      },
      endpoint: "/ws:serch",
      subscribeDestination: "/platform/${Database.guest.id}"
    );

    super.onReady();
  }

  void _listener(dynamic data) {
    if(data is List) {
      if(data.every((d) => d.containsKey("timelines"))) {
        List<TripResponse> list = data.map((d) => TripResponse.fromJson(d)).toList();

        if(list.every((d) => d.isWaiting)) {
          ActivityRequestedController.data.updateTrips(list);
        } else if(list.every((d) => d.isActive)) {
          ActivityActiveController.data.updateTrips(list);
        } else {
          ActivityHistoryController.data.updateTrips(list);
        }
      }
    } else {
      try {
        if(data.containsKey("timelines")) {
          TripResponse response = TripResponse.fromJson(data);

          if(response.isWaiting) {
            ActivityRequestedController.data.addTrip(response);
          } else if(response.isActive) {
            ActivityActiveController.data.addTrip(response);
          } else {
            ActivityHistoryController.data.addTrip(response);
          }
        }
      } catch (_) { }
    }
  }

  @override
  void onClose() {
    _socket.disconnect();

    super.onClose();
  }

  void selectRoute(int index) {
    state.routeIndex.value = index;
    update();
  }

  void _sendServerUpdate() async {
    String fcmToken = await _firebaseService.getFcmToken();
    if(fcmToken.isNotEmpty) {
      await _connect.patch(endpoint: "/guest/update/fcm?token=$fcmToken&guest=${Database.guest.id}");
    }

    try {
      String timezone = await FlutterTimezone.getLocalTimezone();
      await _connect.patch(endpoint: "/guest/update/timezone?zone=$timezone&guest=${Database.guest.id}");
    } catch (_) { }
  }
}