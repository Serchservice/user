import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

final Socket socket = Socket.instance;

class HomeController extends GetxController {
  HomeController();
  final state = HomeState();
  static HomeController get data => Get.find<HomeController>();

  final ConnectService _connect = Connect();
  final AuthValidatorService _apiService = AuthValidator();
  final FirebaseMessagingService _firebaseService = FirebaseMessagingImplementation();
  final AuthValidatorService _authService = AuthValidator();
  final LocationService _locationService = LocationImplementation();

  late HomeDashboardService dashboard;
  late HomeMessagingService messaging;
  late HomeActivityService activity;
  late HomeEventService event;
  late HomeCallService call;
  late HomeSharedLinkService shared;

  StreamSubscription<dynamic>? stream;

  List<SerchCategory> quickActions = [
    SerchCategory.quick(header: "Drive to", image: Media.driveTo, mode: "DRIVE"),
    SerchCategory.quick(header: "Speak to", image: Media.speakTo, mode: "SPEAK"),
    SerchCategory.quick(header: "Request", image: Media.request, mode: "REQUEST"),
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
    _locationService.getAddress(onSuccess: (address, position) => Database.saveAddress(address), onError: (error) {});

    dashboard = HomeDashboard(controller: this);
    messaging = HomeMessaging(controller: this);
    activity = HomeActivity(controller: this);
    event = HomeEvent(controller: this);
    call = HomeCall(controller: this);
    shared = HomeSharedLink(controller: this);

    _authService.validateSession(
      onSuccess: (success) {
        _apiService.fetchAccounts();
        messaging.loadSpeakWithSerchMessages();
        dashboard.loadCategories();
        dashboard.loadPopularCategories();
        dashboard.fetchDashboard(true);
        call.fetchCalls(showLoader: true);
        messaging.fetchChats(showLoader: true);
        activity.fetchSchedules(showLoader: true);
        activity.fetchInvites(showLoader: true);
        activity.fetchTrips(showLoader: true);
        shared.fetch(showLoader: true);
      },
      onError: (error) {
        Navigate.all(EmailCheckerLayout.route);
        notify.error(message: error);
      }
    );

    super.onInit();
  }

  @override
  void onReady() {
    AnalyticsEngine.logOpen();

    _firebaseService.foreground();
    _sendServerUpdate();

    stream = CommonUtility.fetch(
      action: () {
        messaging.loadSpeakWithSerchMessages();
        dashboard.fetchDashboard(false);
      },
      durationInSeconds: 60
    );

    socket.initialize(
      callback: (frame) {
        if (frame.body != null) {
          dynamic data = jsonDecode(frame.body!);
          if (data is String) {
            if (Navigate.navigatorKey.currentState != null) {
              notify.tip(message: data);
            } else if (Navigate.navigatorKey.currentContext != null) {
              notify.tip(message: data);
            }
          } else if (data is Map) {
            if(data.containsKey("room")) {
              messaging.prepareData(data: data as Map<String, dynamic>);
            } else if(data.containsKey("channel")) {
              notify.tip(message: data["error"]);
            } else if(data.containsKey("timelines")) {
              activity.prepareTrip(data);
            }
          } else if(data is List) {
            log(data, from: "List - Socket");
            if(data.any((d) => d.containsKey("schedules"))) {
              activity.updateScheduleGroups(data);
            } else if(data.any((d) => d.containsKey("closedOnTime"))) {
              activity.updateSchedules(data);
            } else if(data.any((d) => d.containsKey("timelines"))) {
              activity.prepareTrips(data);
            }
          } else {
            //
          }
        }
      },
      endpoint: "/ws:serch",
      subscribeDestination: "/platform/${Database.auth.id}"
    );
    super.onReady();
  }

  void _sendServerUpdate() async {
    String fcmToken = await _firebaseService.getFcmToken();
    if(fcmToken.isNotEmpty) {
      await _connect.patch(endpoint: "/account/fcm/update?token=$fcmToken");
    }

    try {
      String timezone = await FlutterTimezone.getLocalTimezone();
      await _connect.patch(endpoint: "/account/update?timezone=$timezone");
    } catch (_) { }
  }

  @override
  void onClose() {
    stream?.cancel();
    socket.disconnect();
    if(state.sockets.isNotEmpty) {
      for (var socket in state.sockets) {
        socket.disconnect();
      }
    }
    super.onClose();
  }

  void selectRoute(int index) {
    state.routeIndex.value = index;
    update();
  }

  Widget? buildEventLayout() {
    if(state.events.isNotEmpty) {
      double space = Sizing.space(8);

      return Container(
        constraints: BoxConstraints(maxHeight: Get.height / 2),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LoadingButton(
                    text: state.isMinimized.value ? "View details" : "Minimize details",
                    buttonColor: Get.theme.colorScheme.surface,
                    textColor: Get.theme.primaryColor,
                    textSize: 12,
                    borderRadius: 30,
                    padding: EdgeInsets.all(Sizing.space(6)),
                    onClick: state.isMinimized.toggle,
                  )
                ],
              ),
              const SizedBox(height: 10),
              ...state.events.map((event) {
                bool isLast = state.events.length - 1 == state.events.indexOf(event);

                return Padding(
                  padding: isLast
                    ? EdgeInsets.symmetric(horizontal: space)
                    : EdgeInsets.only(bottom: space, left: space, right: space),
                  child: Swiper(
                    onLeftSwipe: (details) {
                      if(event.trip != null) {
                        this.event.removeTripEventById(event.trip!.id);
                      } else if(event.call != null) {
                        this.event.removeCallEventByChannel(event.call!.state.call.value.channel);
                      }
                    },
                    iconOnLeftSwipe: CupertinoIcons.trash,
                    iconOnRightSwipe: CupertinoIcons.trash,
                    iconSize: 16,
                    iconColor: CommonColors.error,
                    onRightSwipe: (details) {
                      if(event.trip != null) {
                        this.event.removeTripEventById(event.trip!.id);
                      } else if(event.call != null) {
                        this.event.removeCallEventByChannel(event.call!.state.call.value.channel);
                      }
                    },
                    child: event
                  )
                );
              })
            ],
          ),
        ),
      );
    } else {
      return null;
    }
  }
}