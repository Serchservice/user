import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:user/library.dart';

class ChatState {
  /// The room mate id
  RxString roommate = RxString("");

  /// The room id
  RxString room = RxString("");

  /// The room data
  Rx<ChatRoom> chatRoom = ChatRoom.empty().obs;

  /// For argument data
  Rx<Object> args = Object().obs;

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

  /// Checks if the user is bookmarking the current chat member
  RxBool isBookmarking = false.obs;

  /// Checks if the user is requesting for the current chat member
  RxBool isRequesting = false.obs;

  /// Checks if the current chat member was requested by the user
  RxBool hasRequested = false.obs;

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
}