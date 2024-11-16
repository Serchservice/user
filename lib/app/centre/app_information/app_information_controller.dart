import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:user/library.dart';

final InAppReview inAppReview = InAppReview.instance;

class AppInformationController extends GetxController {
  AppInformationController();
  final state = AppInformationState();
  final ConnectService _connect = Connect();

  @override
  void onInit() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    state.appName.value = packageInfo.appName;
    state.appPackage.value = packageInfo.packageName;
    state.appVersion.value = packageInfo.version;
    state.appBuildNumber.value = packageInfo.buildNumber;

    super.onInit();
  }

  @override
  void onReady() {
    fetchAppRating();

    try {
      state.hasUnreadMessages.value = HomeController.data.state.hasSerchMessage.value;
    } catch (_) { }
    super.onReady();
  }

  void fetchAppRating() async {
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
    } else {
      notify.tip(message: "Unable to use in-app rating at the moment. Try again later");
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
        icon: Platform.isAndroid ? Icons.play_arrow : Icons.apple,
        header: "${ Platform.isIOS ? "App Store" : "Play Store" } rating"
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
        header: "Serch for Guests",
        icon: Icons.person_add_alt_1,
        index: 1,
        path: Links.web("/guest"),
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
}