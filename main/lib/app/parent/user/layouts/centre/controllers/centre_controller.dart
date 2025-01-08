import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CentreController extends GetxController {
  CentreController();
  static CentreController get data => Get.find<CentreController>();

  final state = CentreState();

  List<ButtonView> quickActions = [
    ButtonView(
      icon: Icons.chat_bubble_rounded,
      header: "Speak with Serch",
      path: SpeakWithSerchLayout.route
    ),
    ButtonView(
      icon: Icons.link_rounded,
      header: "My Links",
      path: SharedLinksLayout.route
    ),
    ButtonView(
      icon: Icons.help_outline_sharp,
      header: "Help",
      path: HelpLayout.route
    ),
  ];

  List<ButtonView> tabs = [
    ButtonView(
      icon: Icons.account_circle_rounded,
      header: "Account",
      body: "Manage your profile and account details",
      path: AccountLayout.route
    ),
    ButtonView(
      icon: Icons.wallet_rounded,
      header: "Wallet",
      body: "Manage your wallet transactions and funds",
      path: WalletLayout.route
    ),
    ButtonView(
      icon: Icons.bookmarks_rounded,
      header: "Bookmarks",
      body: "Manage the providers you've saved for later",
      path: BookmarkLayout.route
    ),
    ButtonView(
      icon: Icons.star_rate_rounded,
      header: "Rating",
      body: "Understand why your rating is low or high",
      path: RatingLayout.route
    ),
    ButtonView(
      icon: Icons.account_tree_rounded,
      header: "Referral",
      body: "See what your referral program is building",
      path: ReferralLayout.route
    ),
    ButtonView(
      icon: Icons.security_rounded,
      header: "Privacy and Security",
      body: "Protect your account in the best way possible",
      path: PrivacyAndSecurityLayout.route
    ),
    ButtonView(
      icon: Icons.settings_suggest_rounded,
      header: "Preferences",
      body: "Personalize your app settings the way that suits you",
      path: PreferenceLayout.route
    ),
    ButtonView(
      icon: Icons.apps_rounded,
      header: "App Information",
      body: "Rate the Serch platform and see platform updates",
      path: AppInformationLayout.route,
      index: 1
    ),
  ];

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
        RouteNavigator.openLink(url: "https://nearby.serchservice.com");
      } else if(PlatformEngine.instance.isAndroid) {
        RouteNavigator.openLink(url: "https://play.google.com/store/apps/details?id=com.serchservice.drive");
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