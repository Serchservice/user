import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

final Socket socket = Socket.instance;

class ParentController extends GetxController {
  ParentController();

  final ParentState state = ParentState();

  static ParentController get data => Get.find<ParentController>();

  static void bind() {
    if(!Get.isRegistered<HomeController>()) {
      Get.put<HomeController>(HomeController());
    }

    if(!Get.isRegistered<EventController>()) {
      Get.put<EventController>(EventController());
    }

    if(!Get.isRegistered<ConnectController>()) {
      Get.put<ConnectController>(ConnectController());
    }

    ChatRoomListController.bind();

    if(!Get.isRegistered<CallChannelListController>()) {
      Get.put<CallChannelListController>(CallChannelListController());
    }

    CallConfiguration.bind();

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

    if(!Get.isRegistered<SpeakWithSerchController>()) {
      Get.put<SpeakWithSerchController>(SpeakWithSerchController());
    }

    if(!Get.isRegistered<CentreController>()) {
      Get.put<CentreController>(CentreController());
    }

    if(!Get.isRegistered<SharedLinksController>()) {
      Get.put<SharedLinksController>(SharedLinksController());
    }

    try {
      if(!ParentController.data.initialized) {
        Get.lazyPut<ParentController>(() => ParentController());
      }
    } catch (_) {
      Get.lazyPut<ParentController>(() => ParentController());
    }
  }

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
    if(PlatformEngine.instance.isMobile) ...[
      DynamicIconButtonView(
        icon: Icons.category_outlined,
        active: Icons.category_rounded,
        title: "Connect",
        index: 1,
      )
    ],
    DynamicIconButtonView(
      icon: Icons.connect_without_contact_rounded,
      active: Icons.connect_without_contact_rounded,
      title: "Activity",
      index: 2,
    ),
    DynamicIconButtonView(
      icon: Icons.account_circle_outlined,
      active: Icons.account_circle_rounded,
      title: "Centre",
      index: 3
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

    socket.initialize(
      callback: (frame) {},
      endpoint: "/ws:serch",
      subscribeDestination: "/platform/${Database.auth.id}"
    );

    super.onReady();
  }

  @override
  void onClose() {
    socket.disconnect();

    super.onClose();
  }

  void selectRoute(int index) {
    state.routeIndex.value = index;
    update();
  }
}