import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  AccountController();
  static AccountController get data => Get.find<AccountController>();

  final state = AccountState();

  final ConnectService _connect = Connect();

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  void stopShowingAccount() {
    Database.saveNotifier(Database.notifier.copyWith(showAccount: false));
    state.showAccount.value = false;
  }

  void fetchProfile() async {
    state.isFetching.value = true;
    var response = await _connect.get(endpoint: "/profile");

    if(response.isOk) {
      state.isFetching.value = false;
      Profile profile = Profile.fromJson(response.data);
      updateProfile(profile);
    } else {
      notify.error(message: response.message);
    }
  }

  void updateProfile(Profile profile) {
    state.profile.value = profile;

    Country country = Database.countries.firstWhere((element) {
      return element.code.toLowerCase() == profile.phoneInfo.isoCode;
    }, orElse: () => Country.primary());

    state.phone.value = "${country.flag} ${profile.phoneInfo.phoneNumber}";
  }

  List<ButtonView> buttons = [
    ButtonView(
      icon: Icons.link_rounded,
      header: "Shared Links",
      body: "Manage your provideShared links. See how your providers are being shared",
      path: SharedLinksLayout.route
    ),
  ];

  List<ButtonView> securities = [
    ButtonView(
      index: 0,
      icon: Icons.logout_rounded,
      header: "Sign out",
    ),
    ButtonView(
      index: 1,
      icon: Icons.delete_rounded,
      header: "Delete my account",
    ),
  ];

  void openSecurity(ButtonView view) {
    if(view.index == 0) {
      AccountSignOut.open();
    } else {
      AccountDelete.open();
    }
  }

  List<ButtonView> profile() => [
    ButtonView(
      icon: Icons.person_outline_rounded,
      header: "FirstName",
      body: state.profile.value.firstName,
    ),
    ButtonView(
      icon: Icons.person_3_outlined,
      header: "LastName",
      body: state.profile.value.lastName,
    ),
    ButtonView(
      icon: Icons.phone_outlined,
      header: "Phone Number",
      body: state.phone.value,
    ),
    ButtonView(
      icon: Icons.people_outline_outlined,
      header: "Gender",
      body: state.profile.value.gender,
    ),
    ButtonView(
      icon: Icons.email_outlined,
      header: "Email Address",
      body: state.profile.value.emailAddress,
    ),
  ];
}