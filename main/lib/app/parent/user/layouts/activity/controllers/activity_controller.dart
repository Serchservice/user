import 'package:user/library.dart';
import 'package:get/get.dart';

class ActivityController extends GetxController {
  ActivityController();
  static ActivityController get data => Get.find<ActivityController>();

  final ActivityState state = ActivityState();

  List<ButtonView> tabs = [
    ButtonView(header: "Requested"),
    ButtonView(header: "Active"),
    ButtonView(header: "History"),
  ];

  void onTap(int index) {
    state.current.value = index;
  }

  List<ButtonView> get sections => [
    ButtonView(header: "Trip", index: 0),
    ButtonView(header: "Schedule", index: 1),
  ];

  List<ButtonView> get filterButtons => [
    ButtonView(header: "All", index: 0),
    ButtonView(header: "Mechanic", index: 1, body: "MECHANIC"),
    ButtonView(header: "Plumber", index: 2, body: "PLUMBER"),
    ButtonView(header: "Electrician", index: 3, body: "ELECTRICIAN"),
    ButtonView(header: "House Keeper", index: 4, body: "HOUSE_KEEPER"),
    ButtonView(header: "Carpenter", index: 5, body: "CARPENTER"),
  ];

  List<ButtonView> get sharedButtons => [
    ButtonView(header: "All", index: 0),
    ButtonView(header: "Shared", index: 1),
    ButtonView(header: "Not shared", index: 2),
  ];
}