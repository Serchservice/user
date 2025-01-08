import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:user/library.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  HomeController();
  static HomeController get data => Get.find<HomeController>();
  final state = HomeState();

  final ConnectService _connect = Connect();
  final Socket _socket = Socket();
  final AuthValidatorService _authService = AuthValidator();
  final FirebaseMessagingService _firebaseService = FirebaseMessagingImplementation();

  StreamSubscription<dynamic>? stream;

  SliverGridDelegateWithFixedCrossAxisCount count() {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisExtent: 120,
      mainAxisSpacing: 8
    );
  }

  @override
  void onInit() {
    _authService.validateSession(
      onSuccess: (success) {
        _authService.fetchAccounts();
        _sendServerUpdate();
        _fetchDashboard(true, true);
        _loadCategories();
        _loadPopularCategories();
      },
      onError: (error) {
        EmailCheckerLayout.all();
        notify.error(message: error);
      }
    );

    super.onInit();
  }

  void _sendServerUpdate() async {
    String fcmToken = await _firebaseService.getFcmToken();
    if(fcmToken.isNotEmpty) {
      await _connect.patch(endpoint: "/account/update/fcm?token=$fcmToken");
    }

    try {
      String timezone = await FlutterTimezone.getLocalTimezone();
      await _connect.patch(endpoint: "/account/update/timezone?zone=$timezone");
    } catch (_) { }
  }

  Future<void> _fetchDashboard(bool showLoader, bool withError) async {
    if(showLoader) {
      state.isLoading.value = true;
    }

    var response = await _connect.get(endpoint: "/account/dashboard");

    if(response.isOk) {
      state.dashboard.value = Dashboard.fromJson(response.data);
      state.isLoading.value = false;
    } else if(withError) {
      notify.error(message: response.message);
    }
  }

  void _loadCategories() async {
    state.isFetchingCategories.value = true;
    var response = await _connect.get(endpoint: "/category/all");
    if(response.isOk) {
      state.isFetchingCategories.value = false;
      List<dynamic> data = response.data;
      List<SerchCategory> categories = data.map((e) => SerchCategory.fromJson(e)).toList();
      state.categories.value = categories;
    } else {
      notify.error(message: response.message);
    }
  }

  void _loadPopularCategories() async {
    state.isFetchingPopularCategories.value = true;
    var response = await _connect.get(endpoint: "/category/popular");
    if(response.isOk) {
      state.isFetchingPopularCategories.value = false;
      List<dynamic> data = response.data;
      List<SerchCategory> popularCategories = data.map((e) => SerchCategory.fromJson(e)).toList();
      state.popularCategories.value = popularCategories;
    } else {
      notify.error(message: response.message);
    }
  }

  @override
  void onReady() {
    stream = CommonUtility.fetch(
      action: () {
        _fetchDashboard(false, false);
      },
      durationInSeconds: 60
    );

    _socket.initialize(
      callback: (frame) { },
      endpoint: "/ws:serch",
      subscribeDestination: "/platform/${Database.auth.id}"
    );

    announcePresence();

    super.onReady();
  }

  void announcePresence({String room = ""}) {
    if(_socket.isConnected) {
      _socket.send(destination: "/chat/announce/$room");
    }
  }

  double contentHeight = 160;
  double contentWidth = 120;
  double contentShrinkExtent = 130;

  List<ButtonView> moreTips = [
    ButtonView(
      header: "Get the fix you want without inviting anyone.",
      image: Media.commonSpeak,
      index: 0,
      color: Color(0xfff5f3f4),
      body: "Speak with a provider"
    ),
    ButtonView(
      header: "Nearby mechanic? Nearby provider?",
      image: Media.commonDrive,
      index: 1,
      color: Color(0xfff5f3f4),
      body: "Drive now"
    ),
    ButtonView(
      header: "Looking for a particular skill?",
      image: Media.commonSkill,
      index: 2,
      color: Color(0xfff4e9cd),
      body: "Search here"
    ),
  ];

  List<ButtonView> goFurtherTips = [
    ButtonView(
      header: "Account trust toolkit",
      image: Media.commonAccountTrust,
      index: 0,
      color: Color(0xffe1e5f2),
      colors: [Color(0xffe1e5f2), Color(0xfff0f2fa)],
    ),
    ButtonView(
      header: "Can't do it alone? Share it",
      image: Media.commonShare,
      index: 1,
      color: Color(0xff3772ff),
      colors: [Color(0xff3772ff), Color(0xff638cff)],
    ),
    ButtonView(
      header: "Got a gender preference for your trips?",
      image: Media.commonGender,
      index: 2,
      color: Color(0xff858ae3),
      colors: [Color(0xff858ae3), Color(0xffa0a5ed)],
    ),
  ];

  void onMoreTap(ButtonView view) {
    if(view.index == 0) {
      RequestEntryLayout.speak();
    } else if(view.index == 1) {
      RequestEntryLayout.drive();
    } else {
      SkillSearchLayout.to();
    }
  }

  void onGoFurtherTap(ButtonView view) {
    if(view.index == 0) {
      AccountTrustSheet.open(view.color);
    } else if(view.index == 1) {
      GoFurtherWithSharing.open(view.color);
    } else {
      GoFurtherWithGenderPreference.open(view.color);
    }
  }

  void openAccounts() {
    AccountPickerLayout.open(onGuestSuccess: (g) => Navigate.all(GuestParentLayout.route));
  }

  @override
  void onClose() {
    stream?.cancel();

    super.onClose();
  }

  void refreshData() {
    _fetchDashboard(true, true);
  }
}