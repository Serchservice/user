import 'package:user/library.dart';
import 'package:get/get.dart';

class AppUpdatesController extends GetxController {
  AppUpdatesController();

  List<UpdateLogView> updates = [
    UpdateLogView(
      header: "1.0.1: Bug fixes and workflow change.",
      content: [
        "Fixed initialization bugs.",
        "Fixed in-app rating bug",
        "Removed country and state validator when app opens.",
      ],
      date: "4th October, 2024",
      index: 1
    ),
    UpdateLogView(
      header: "1.0.0: Launching the Serch Business platform.",
      content: [
        "Add your service providers to your organization account.",
        "Track every service activities of your service providers.",
        "Control the visibility of your service providers.",
        "Grow your organization's revenue with the business platform.",
        "Add your shops to increase visibility and outreach.",
      ],
      date: "25th September, 2024",
      index: 0
    )
  ];
}