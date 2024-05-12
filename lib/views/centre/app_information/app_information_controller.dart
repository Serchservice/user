import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:user/library.dart';

class AppInformationController extends GetxController {
  AppInformationController();
  final state = AppInformationState();
  final HomeController homeController = Get.find<HomeController>();
  final Connect _connect = Connect();

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
    super.onReady();
  }

  void fetchAppRating() async {
    try {
      var res = await _connect.get(endpoint: "/rating/app");
      ApiResponse response = ApiResponse.fromJson(res.data);
      state.isLoading.value = false;
      if(response.isOk) {
        AppRating rating = AppRating.fromJson(response.data);
        Database.saveAppRating(rating);
        state.rating.value = rating.rating;
        state.comment.value = rating.comment;
      }
    } on Exception catch (_) {
      state.isLoading.value = false;
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
        header: "${ Platform.isIOS ? "App Store" : "Google Playstore" } rating"
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
              header: "${state.appName.value} In-App Rating",
              tag: "APP"
            );
          } else {
            /// TODO:: Add store link here
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
        path: Links.web("/career"),
      ),
      ButtonView(
        header: "Non-Discrimination Policy",
        icon: Icons.warning_rounded,
        path: Links.web("/career"),
      ),
      ButtonView(
        header: "Privacy Policy",
        icon: Icons.privacy_tip_rounded,
        path: Links.web("/career"),
      ),
      ButtonView(
        header: "Terms and Condition",
        icon: Icons.confirmation_number_rounded,
        path: Links.web("/career"),
      ),
      ButtonView(
        header: "Zero Tolerance Policy",
        icon: Icons.not_interested_rounded,
        path: Links.web("/career"),
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
        path: Links.web("/career"),
      ),
      ButtonView(
        header: "Serch for Individuals",
        icon: Icons.person_3_rounded,
        index: 1,
        path: Links.web("/career"),
      ),
      ButtonView(
        header: "Serch for Business",
        icon: Icons.business_center_rounded,
        path: Links.web("/career"),
      ),
      ButtonView(
        header: "Serch for Providers",
        icon: Icons.supervised_user_circle_rounded,
        path: Links.web("/career"),
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