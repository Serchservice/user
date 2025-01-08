import 'package:get/get.dart';
import 'package:user/library.dart';

class ConnectController extends GetxController {
  ConnectController();
  final state = ConnectState();

  List<ButtonView> tabs = [
    ButtonView(header: "Chats"),
    ButtonView(header: "Calls"),
  ];

  void onTap(int index) {
    state.current.value = index;
  }
}