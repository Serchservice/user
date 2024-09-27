import 'package:get/get.dart';
import 'package:user/library.dart';

class AppUpdatesController extends GetxController {
  AppUpdatesController();

  List<UpdateLogView> updates = [
    UpdateLogView(
      header: "1.0.0: Launching the Serch platform.",
      content: [
        "Connect easily with service providers.",
        "Chat, Call or Schedule a fix with service providers.",
        "Tip2Fix a service problem with a service provider.",
        "View the profile of the service provider before going on a trip.",
        "A Two-Way rating for both the user and the service provider.",
        "Bookmark a service provider to ease future conversations.",
        "Search for a service provider within your location radius.",
        "Drive to the nearby shop location with our quickest search mode",
        "Share your verified and trusted provider to loved ones and make extra money.",
      ],
      date: "25th September, 2024",
      index: 0
    )
  ];
}