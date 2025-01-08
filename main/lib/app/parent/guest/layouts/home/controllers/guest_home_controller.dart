import 'dart:ui';

import 'package:user/library.dart';
import 'package:get/get.dart';

class GuestHomeController extends GetxController {
  GuestHomeController();
  static GuestHomeController get data => Get.find<GuestHomeController>();
  final state = GuestHomeState();

  double contentHeight = 160;
  double contentWidth = 120;
  double contentShrinkExtent = 130;

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
  ];

  void onGoFurtherTap(ButtonView view) {
    if(view.index == 0) {
      GuestAccountTrustSheet.open(view.color);
    } else if(view.index == 1) {
      GoFurtherWithSharing.open(view.color);
    }
  }

  void openAccounts() {
    AccountPickerLayout.open(
      onUserSuccess: () => Navigate.all(ParentLayout.route),
      onGuestSuccess: (guest) {
        GuestParentController.data.state.guest.value = guest;

        Navigate.back();
      }
    );
  }
}