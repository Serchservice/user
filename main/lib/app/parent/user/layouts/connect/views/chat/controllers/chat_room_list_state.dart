import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:user/library.dart';

class ChatRoomListState {
  /// Current chats filter index
  RxInt filter = RxInt(0);

  RxString filterString = RxString("");

  RxList<ChatRoom> rooms = RxList([]);
}