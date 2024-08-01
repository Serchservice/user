import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestHomeController extends GetxController {
  GuestHomeController();
  final state = GuestHomeState();
  static GuestHomeController get data => Get.find<GuestHomeController>();

  final AuthValidatorService _apiService = AuthValidator();
  final SocketService _socket = Socket();
  final SocketService _socketed = Socket();

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

    _socketed.initialize(
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
    _socketed.disconnect();
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
}