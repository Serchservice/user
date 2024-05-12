import 'package:get/get.dart';
import 'package:user/library.dart';

class AppUpdatesController extends GetxController {
  AppUpdatesController();

  List<UpdateLogView> updates = [
    UpdateLogView(
      header: "1.0.0: Launching the Serch platform in all stores.",
      content: [
        "Connect easily with service providers.",
        "Chat, Call or Schedule a fix with service providers.",
        "Tip2Fix a service problem with a service provider.",
        "View the profile of the service provider before going on a trip.",
        "A Two-Way rating for both the user and the service provider.",
        "Bookmark a service provider to ease future conversations.",
        "Serch for a service provider within your location radius.",
        "ProvideShare a service provider with another user or person.",
      ],
      date: "6/6/2024",
      index: 0
    )
  ];
}