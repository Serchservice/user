import 'package:user/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HelpController extends GetxController {
  HelpController();
  final state = HelpState();
  final ParentController homeController = ParentController.data;

  static String detail(String social) => "Follow us on $social, and make your suggestions.";

  ButtonView chatWithSerch = ButtonView(
    header: "Speak with Serch",
    body: "Manage your issues and conversations with Serch",
    icon: CupertinoIcons.tickets_fill,
    path: SpeakWithSerchLayout.route,
  );

  List<ButtonView> help = [
    ButtonView(
      header: "Mail",
      body: "Send us an email when it is your best option.",
      icon: CupertinoIcons.mail_solid,
      path: "account@serchservice.com",
      index: 0
    ),
    ButtonView(
      header: "Call Centre",
      body: "Get all the help you need with a live assistant.",
      icon: Icons.phone,
      path: "+18445871030",
      index: 1
    ),
    ButtonView(
      header: "Safe-Guard Community",
      body: "Join Serch SG Community and help us improve our safety measures.",
      icon: FontAwesomeIcons.whatsapp,
      path: "https://chat.whatsapp.com/IPWEBQi7HRG7jJQiOWdcJT",
      index: 2
    ),
    ButtonView(
      header: "Visit help center",
      body: "Browse our help documentation to find possible solutions",
      icon: FontAwesomeIcons.asterisk,
      path: "https://help.serchservice.com",
      index: 3
    ),
  ];

  List<ButtonView> media = [
    ButtonView(
      header: "LinkedIn",
      icon: FontAwesomeIcons.linkedin,
      path: "https://www.linkedin.com/company/serchservice",
      index: 0
    ),
    ButtonView(
      header: "Instagram",
      icon: FontAwesomeIcons.instagram,
      path: "https://www.instagram.com/serchservice",
      index: 1
    ),
    ButtonView(
      header: "X",
      icon: FontAwesomeIcons.twitter,
      path: "https://www.x.com/serchservice",
      index: 2
    ),
    ButtonView(
      header: "YouTube",
      icon: FontAwesomeIcons.youtube,
      path: "https://www.youtube.com/@serchservice",
      index: 3
    ),
    ButtonView(
      header: "TikTok",
      icon: FontAwesomeIcons.tiktok,
      path: "https://www.tiktok.com/@serchservice",
      index: 4
    ),
  ];
}