import 'package:flutter/cupertino.dart';
import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestAccountController extends GetxController {
  GuestAccountController();
  static GuestAccountController get data => Get.find<GuestAccountController>();

  final state = GuestAccountState();

  List<ButtonView> buttons = [
    // ButtonView(
    //   icon: Icons.link_rounded,
    //   header: "Shared Links",
    //   body: "Manage your provideShared links. See how your providers are being shared",
    //   path: GuestSharedLinksLayout.route
    // ),
  ];

  List<ButtonView> securities = [
    ButtonView(
      index: 1,
      icon: CupertinoIcons.layers_fill,
      header: GuestParentController.data.state.guest.value.name,
      body: "Tap to switch account",
    ),
  ];

  List<ButtonView> profile() => [
    ButtonView(
      icon: Icons.person_outline_rounded,
      header: "FirstName",
      body: GuestParentController.data.state.guest.value.firstName,
    ),
    ButtonView(
      icon: Icons.person_3_outlined,
      header: "LastName",
      body: GuestParentController.data.state.guest.value.lastName,
    ),
    ButtonView(
      icon: Icons.people_outline_outlined,
      header: "Gender",
      body: GuestParentController.data.state.guest.value.gender,
    ),
    ButtonView(
      icon: Icons.email_outlined,
      header: "Email Address",
      body: GuestParentController.data.state.guest.value.emailAddress,
    ),
    ButtonView(
      icon: Icons.phone_outlined,
      header: "Joined the Serch platform on",
      body: GuestParentController.data.state.guest.value.joinedAt,
    ),
  ];
}