import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestHomeController extends GetxController {
  GuestHomeController();
  final state = GuestHomeState();
  static GuestHomeController get data => Get.find<GuestHomeController>();

  final AuthValidatorService _apiService = AuthValidator();
  final SocketService _socket = Socket();
  final SocketService _socketIn = Socket();

  late GuestHomeActivityService activity;
  late GuestHomeEventService event;

  StreamSubscription<dynamic>? stream;

  @override
  void onInit() {
    _apiService.fetchAccounts();
    activity = GuestHomeActivity(controller: this);
    event = GuestHomeEvent(controller: this);
    super.onInit();
  }

  @override
  void onReady() {
    activity.fetchTrips(showLoader: true);
    activity.fetchInvites(showLoader: true);

    _socket.initialize(
      callback: (frame) {
        if (frame.body != null) {
          dynamic data = jsonDecode(frame.body!);
          if (data is String) {
            notify.tip(message: data);
          } else if (data is Map && data.containsKey("timelines")) {
            activity.prepareTrip(data);
          } else if(data is List && data.any((d) => d.containsKey("timelines"))) {
            activity.prepareTrips(data);
          }
        }
      },
      endpoint: "/ws:serch",
      subscribeDestination: "/platform/${Database.guest.id}"
    );

    _socketIn.initialize(
      callback: (frame) {
        if (frame.body != null) {
          dynamic data = jsonDecode(frame.body!);
          if (data is String) {
            notify.tip(message: data);
          } else if (data is Map && data.containsKey("link")) {
            updateGuestData(data);
          }
        }
      },
      endpoint: "/ws:serch",
      subscribeDestination: "/platform/${Database.guest.id}/${Database.preference.active}"
    );

    refreshGuest();

    stream = CommonUtility.fetch(
      action: () {
        refreshGuest();
      },
      durationInSeconds: 60
    );
    super.onReady();
  }

  @override
  void onClose() {
    _socket.disconnect();
    _socketIn.disconnect();
    stream?.cancel();
    super.onClose();
  }

  void selectRoute(int index) {
    state.routeIndex.value = index;
    update();
  }

  void updateTheme(ThemeType theme) {
    if(theme == ThemeType.light) {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.dark);
    }
    state.preference.value = state.preference.value.copyWith(theme: theme);
    Database.savePreference(state.preference.value);
    state.theme.value = theme;
  }

  void confirmEmail() async {
    if(state.guest.value.confirmed) {
      GuestBecomeUser.open(
        guestId: state.guest.value.id,
        linkId: state.guest.value.link.linkId
      );
    } else {
      AskToVerifySheet.open(
        emailAddress: state.guest.value.emailAddress,
        onSuccess: () => GuestBecomeUser.open(
          guestId: state.guest.value.id,
          linkId: state.guest.value.link.linkId
        ),
      );
    }
  }

  void refreshGuest() {
    if(_socket.stompClient.connected) {
      _socket.send(destination: "/guest/refresh", message: {
        "id": Database.guest.id,
        "link_id": Database.preference.active
      });
    }
  }
  
  void updateGuestData(dynamic data) {
    Guest guest = Guest.fromJson(data);
    state.guest.value = guest;
    Database.saveGuest(guest);
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
                      }
                    },
                    iconOnLeftSwipe: CupertinoIcons.trash,
                    iconOnRightSwipe: CupertinoIcons.trash,
                    iconSize: 16,
                    iconColor: CommonColors.error,
                    onRightSwipe: (details) {
                      if(event.trip != null) {
                        this.event.removeTripEventById(event.trip!.id);
                      }
                    },
                    child: event
                  )
                );
              }).toList()
            ],
          ),
        ),
      );
    } else {
      return null;
    }
  }
}