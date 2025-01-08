import 'package:get/get.dart';
import 'package:user/library.dart';

class ChatRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatRoomController>(() => ChatRoomController());

    ParentController.bind();
  }
}