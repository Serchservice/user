
import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInformationController extends GetxController {
  AppInformationController();
  final state = AppInformationState();
  final ConnectService _connect = Connect(useToken: Database.isUserActive);

  final InAppReview inAppReview = InAppReview.instance;

  @override
  void onInit() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    state.appName.value = packageInfo.appName;
    state.appPackage.value = packageInfo.packageName;
    state.appVersion.value = packageInfo.version;
    state.appBuildNumber.value = packageInfo.buildNumber;

    if(Database.isUserActive) {
      state.hasUnreadMessages.value = SpeakWithSerchController.data.state.hasSerchMessage.value;
    }

    super.onInit();
  }

  @override
  void onReady() {
    _fetchRating();

    super.onReady();
  }

  void _fetchRating() async {
    var response = await _connect.get(endpoint: "/rating/app");
    state.isLoading.value = false;

    if(response.isOk) {
      AppRating rating = AppRating.fromJson(response.data);
      Database.saveAppRating(rating);
      state.rating.value = rating.rating;
      state.comment.value = rating.comment;
    }
  }

  void _appStoreReview() async {
    bool isAvailable = await inAppReview.isAvailable();
    if(isAvailable) {
      await inAppReview.requestReview();
      notify.tip(
        message: "If you don't see the rating dialog, please use the in-app rating.",
        color: CommonColors.allday
      );
    } else {
      notify.tip(
        message: "Unable to use in-app rating at the moment. Try again later",
        color: CommonColors.allday
      );
    }
  }

  void openRating() {
    List<ButtonView> options = [
      ButtonView(
        icon: Icons.phone_android_rounded,
        header: "In-App Rating",
        index: 0
      ),
      ButtonView(
        index: 1,
        icon: PlatformEngine.instance.isAndroid ? Icons.play_arrow : Icons.apple,
        header: "${ PlatformEngine.instance.isIOS ? "App Store" : "Play Store" } rating"
      )
    ];

    Navigate.bottomSheet(
      sheet: AppInformationSheet(
        options: options,
        header: "Tell us what you think",
        onTap: (view) {
          Navigate.back();
          if(view.index == 0) {
            RatingSheet.open(
              onSuccess: (comment, rating) {
                state.rating.value = rating;
                state.comment.value = comment;
                Database.saveAppRating(Database.rating.copyWith(
                  comment: comment,
                  rating: rating
                ));
                Navigate.back();
              },
            );
          } else {
            _appStoreReview();
          }
        }
      ),
      route: "/centre/app/rating",
      background: Colors.transparent
    );
  }

  void openLegal() {
    List<ButtonView> options = [
      ButtonView(
        header: "Community Guidelines",
        icon: Icons.people_rounded,
        path: Links.web(Constants.communityGuidelines),
      ),
      ButtonView(
        header: "Non-Discrimination Policy",
        icon: Icons.warning_rounded,
        path: Links.web(Constants.nonDiscriminationPolicy),
      ),
      ButtonView(
        header: "Privacy Policy",
        icon: Icons.privacy_tip_rounded,
        path: Links.web(Constants.privacyPolicy),
      ),
      ButtonView(
        header: "Terms and Condition",
        icon: Icons.confirmation_number_rounded,
        path: Links.web(Constants.termsAndConditions),
      ),
      ButtonView(
        header: "Zero Tolerance Policy",
        icon: Icons.not_interested_rounded,
        path: Links.web(Constants.zeroTolerancePolicy),
      ),
    ];

    Navigate.bottomSheet(
      sheet: AppInformationSheet(
        options: options,
        header: "Legal | Serch",
        onTap: (view) {
          RouteNavigator.openWeb(
            header: view.header,
            url: view.path
          );
        }
      ),
      route: "/centre/app/legal",
      background: Colors.transparent
    );
  }

  void openSolution() {
    List<ButtonView> options = [
      ButtonView(
        header: "Serch Marketplace",
        icon: Icons.business_sharp,
        path: Links.web("/marketplace"),
      ),
      ButtonView(
        header: "Serch for Users",
        icon: Icons.person_3_rounded,
        index: 1,
        path: Links.web("/user"),
      ),
      ButtonView(
        header: "Serch for Business",
        icon: Icons.business_center_rounded,
        path: Links.web("/business"),
      ),
      ButtonView(
        header: "Serch for Providers",
        icon: Icons.supervised_user_circle_rounded,
        path: Links.web("/provider"),
      ),
      ButtonView(
        header: "Serch for Associates",
        icon: Icons.assignment_ind_outlined,
        path: Links.web("/provider/associate"),
      ),
    ];

    Navigate.bottomSheet(
      sheet: AppInformationSheet(
        options: options,
        header: "Solutions | Serch",
        onTap: (view) {
          RouteNavigator.openWeb(
            header: view.header,
            url: view.path
          );
        }
      ),
      route: "/centre/app/solutions",
      background: Colors.transparent
    );
  }

  List<ButtonView> options(IconData ratingIcon) => [
    ButtonView(
      header: "Rate the app",
      body: "Tell us what you think about ${state.appName.value}",
      icon: ratingIcon,
      index: 0
    ),
    ButtonView(
      header: "Help",
      body: "Access the support you need whenever you want it",
      icon: Icons.help_rounded,
      index: 1,
      path: HelpLayout.route
    ),
    ButtonView(
      header: "Updates",
      body: "Learn about more ${state.appName.value} updates",
      icon: Icons.update_rounded,
      index: 2,
      path: AppUpdatesLayout.route
    ),
    ButtonView(
      header: "Acknowledgements",
      body: "",
      icon: Icons.hail_rounded,
      index: 3
    ),
    ButtonView(
      header: "Legal",
      body: "",
      icon: Icons.house_siding_rounded,
      index: 4
    ),
    ButtonView(
      header: "Solution for service trips",
      body: "",
      icon: Icons.home_repair_service_rounded,
      index: 5
    ),
    ButtonView(
      header: "Careers in Serch",
      body: "",
      icon: Icons.workspaces_outlined,
      path: Links.web("/career"),
      index: 6
    ),
  ];
}