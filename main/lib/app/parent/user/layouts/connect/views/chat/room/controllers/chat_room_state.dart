import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:user/library.dart';

class ChatRoomState {
  /// The room mate id
  RxString roommate = RxString("");

  /// The room id
  RxString room = RxString("");

  /// The room data
  Rx<ChatRoom> chatRoom = ChatRoom.empty().obs;

  /// Check if it is fetching the room data
  RxBool isFetchingData = RxBool(false);

  /// Show the message that was replied when the replied message is tapped
  RxInt messageIndex = RxInt(-10);

  /// To check if the user has swiped a message for reply
  RxBool isSwiped = false.obs;

  /// To show emoji keyboard
  RxBool emojiShowing = false.obs;

  /// To show the send message button or not
  RxBool showSendButton = false.obs;

  /// To check if the scroll button can be shown
  RxBool showScrollButton = false.obs;

  /// List of selected message indexes - model
  RxList<ChatMessage> selectedMessages = <ChatMessage>[].obs;

  /// The message being selected for more options
  Rx<ChatMessage> openMessage = ChatMessage.empty().obs;

  /// The [ChatReply] model of a swiped message
  Rx<ChatReply> reply = ChatReply.empty().obs;

  /// The message being selected for more options
  Rx<String> selectedMessageId = RxString("");

  /// File to upload
  Rx<SelectedMedia> media = SelectedMedia(path: "").obs;

  RxInt nextPage = RxInt(0);

  RxString error = RxString("");

  RxBool isLastPage = RxBool(false);

  RxBool isLoadingMore = RxBool(false);
}