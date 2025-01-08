import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:user/library.dart';

class ChatRoomListItemState {
  Rx<ChatRoom> room = ChatRoom.empty().obs;
}