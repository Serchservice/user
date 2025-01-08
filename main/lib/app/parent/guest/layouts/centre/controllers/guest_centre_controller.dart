import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestCentreController extends GetxController {
  GuestCentreController();
  final state = GuestCentreState();

  List<ButtonView> tabs = [
    ButtonView(
      icon: Icons.account_circle_rounded,
      header: "Account",
      body: "Manage your profile and account details",
      path: GuestAccountLayout.route
    ),
    ButtonView(
      icon: Icons.security_rounded,
      header: "Privacy and Security",
      body: "Protect your account in the best way possible",
      path: GuestPrivacyAndSecurityLayout.route
    ),
    ButtonView(
      icon: Icons.settings_suggest_rounded,
      header: "Preferences",
      body: "Personalize your app settings the way that suits you",
      path: GuestPreferenceLayout.route
    ),
    ButtonView(
      icon: Icons.apps_rounded,
      header: "App Information",
      body: "Rate the Serch platform and see platform updates",
      path: AppInformationLayout.route,
    ),
  ];

  void becomeAUser() async {
    if(GuestParentController.data.state.guest.value.confirmed) {
      GuestUpgradeLayout.open(
        guestId: GuestParentController.data.state.guest.value.id,
        linkId: GuestParentController.data.state.guest.value.link.linkId
      );
    } else {
      GuestEmailVerification verification = GuestEmailVerification(
        emailAddress: GuestParentController.data.state.guest.value.emailAddress,
        name: GuestParentController.data.state.guest.value.name,
        guestId: GuestParentController.data.state.guest.value.id,
        linkId: GuestParentController.data.state.guest.value.link.linkId,
        becomeAUser: true
      );

      GuestEmailVerificationLayout.to(verification);
    }
  }

  List<ButtonView> more = [
    ButtonView(
      header: "Nearby",
      body: "Easily find nearby places for the things you love and want to see.",
      image: Media.appNearby,
      index: 0
    ),
    ButtonView(
        header: "Serch Provider",
        body: "Earn, grow and get certified with your skill as a service provider.",
        image: Media.appProvider,
        index: 1
    ),
    ButtonView(
        header: "Serch Business",
        body: "Increase your revenue by moving your organization to our business platform.",
        image: Media.appBusiness,
        index: 2
    ),
  ];

  void handleMore(ButtonView view) {
    if(view.index == 0) {
      if(PlatformEngine.instance.isWeb) {
        RouteNavigator.openLink(url: "https://user.serchservice.com");
      } else if(PlatformEngine.instance.isAndroid) {
        RouteNavigator.openLink(url: "https://play.google.com/store/apps/details?id=com.serchservice.user");
      }
    } else if(view.index == 1) {
      if(PlatformEngine.instance.isWeb) {
        RouteNavigator.openLink(url: "https://provider.serchservice.com");
      } else if(PlatformEngine.instance.isAndroid) {
        RouteNavigator.openLink(url: "https://play.google.com/store/apps/details?id=com.serchservice.artisan");
      }
    } else {
      if(PlatformEngine.instance.isWeb) {
        RouteNavigator.openLink(url: "https://business.serchservice.com");
      } else if(PlatformEngine.instance.isAndroid) {
        RouteNavigator.openLink(url: "https://play.google.com/store/apps/details?id=com.serchservice.enterprise");
      }
    }
  }

  void onAppDownload() => RouteNavigator.openLink(url: "https://www.serchservice.com/platform");
}