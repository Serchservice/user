import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:user/library.dart';

class ChatRoomController extends GetxController {
  ChatRoomController();
  final state = ChatRoomState();

  final param = Get.parameters;
  final args = Get.arguments;

  final ConnectService _connect = Connect();
  final Socket _socket = Socket.instance;
  final EndToEndEncryptionService _e2eeService = EndToEndEncryption();
  final ChatRoomTypingController typingController = ChatRoomTypingController();

  ScrollController messageScrollController = ScrollController();
  final TextEditingController textMessage = TextEditingController();
  FocusNode focusNode = FocusNode();

  final _pageSize = 20;
  final messageHeights = <String, double>{};

  Timer? _debounceTimer;

  @override
  void onInit() {
    if(args != null && args["room"] != null) {
      state.chatRoom.value = ChatRoom.fromJson(args["room"]);
    }

    state.room.value = param["room"] ?? "";
    state.roommate.value = param["roommate"] ?? "";

    ChatRoomListController.bind();

    _initRoom().then((room) {
      if(room.room.isNotEmpty) {
        state.chatRoom.value = room;

        _updateMessageList(room.groups);
        state.nextPage.value = 1;

        _scrollToLastMessage();
        _initSocket(room.room);

        ChatRoomListController.data.markAllUnreadMessagesAsRead(room.room);

        typingController.init(room.room, useTyping: true);
        HomeController.data.announcePresence(room: room.room);
      }
    });

    super.onInit();
  }

  Future<ChatRoom> _initRoom() async {
    if(state.chatRoom.value.room.isNotEmpty) {
      return state.chatRoom.value;
    } else if(state.room.value.isNotEmpty) {
      state.isFetchingData.value = true;

      var response = await _connect.get(endpoint: "/chat/room/${state.room.value}");
      if(response.isOk) {
        ChatRoom room = ChatRoom.fromJson(response.data);
        state.isFetchingData.value = false;

        return room;
      } else {
        notify.error(message: response.message);
      }
    } else if(state.roommate.value.isNotEmpty) {
      state.isFetchingData.value = true;

      var response = await _connect.get(endpoint: "/chat/room?roommate=${state.roommate.value}");
      if(response.isOk) {
        ChatRoom room = ChatRoom.fromJson(response.data);
        state.isFetchingData.value = false;

        return room;
      } else {
        notify.error(message: response.message);
      }
    } else {
      notify.error(message: "Access denied. Cannot start chat");
    }

    return ChatRoom.empty();
  }

  void _updateMessageList(List<ChatGroupMessage> newGroups, {bool removeEmptyMessage = false}) {
    List<ChatGroupMessage> existingGroups = List.from(state.chatRoom.value.groups);
    final groups = _mergeGroups(existingGroups, newGroups);

    List<ChatGroupMessage> chatGroups = groups.values.toList();

    if(removeEmptyMessage) {
      for (var g in chatGroups) {
        g.messages.removeWhere((m) => m.id.isEmpty);
      }
    }

    chatGroups.sort((a, b) => a.time.compareTo(b.time));
    state.chatRoom.value = state.chatRoom.value.copyWith(groups: chatGroups);
  }

  void _scrollToLastMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToEnd();
    });
  }

  /// Scroll to the end of the chatting list
  void scrollToEnd() {
    if (messageScrollController.hasClients && messageScrollController.positions.isNotEmpty) {
      // Adjust scroll to the top of the list (reverse order, scroll up)
      messageScrollController.animateTo(
        messageScrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInCubic,
      );
    }
  }

  /// Initialize chat socket
  void _initSocket(String room) {
    state.room.value = room;
    _socket.initialize(
      callback: (frame) {
        if(frame.hasData) {
          ChatRoom room = ChatRoom.fromJson(frame.data);
          state.chatRoom.value = room;
          _updateMessageList(state.chatRoom.value.groups, removeEmptyMessage: true);

          scrollToEnd();
        }
      },
      endpoint: "/ws:serch",
      subscribeDestination: "/platform/${Database.auth.id}/chat/$room"
    );
  }

  void refreshMessages() {
    state.nextPage.value = 0;
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    if(state.isLastPage.isFalse) {
      String endpoint = "/chat/room/${state.room.value}/messages?page=${state.nextPage.value}&size=$_pageSize";
      final response = await _connect.get(endpoint: endpoint);

      if (response.isSuccessful) {
        List<dynamic> result = response.data;
        List<ChatGroupMessage> groups = result.map((r) => ChatGroupMessage.fromJson(r)).toList();

        _updateMessageList(groups);
        state.isLastPage.value = groups.map((group) => group.messages.length).reduce((value, element) => value + element) < _pageSize;
        state.error.value = "";
        state.isLoadingMore.value = false;

        if (state.isLastPage.isFalse) {
          state.nextPage.value++;
        }
      } else {
        state.error.value = response.message;
        state.isLoadingMore.value = false;
      }
    }
  }

  Map<String, ChatGroupMessage> _mergeGroups(List<ChatGroupMessage> existingGroups, List<ChatGroupMessage> newGroups) {
    Map<String, ChatGroupMessage> groupMap = {
      for (var group in existingGroups) group.label: group
    };

    return newGroups.fold<Map<String, ChatGroupMessage>>(groupMap, (map, newGroup) {
      final existingGroup = map[newGroup.label];

      if (existingGroup != null) {
        Map<String, ChatMessage> messageMap = {
          for (var message in existingGroup.messages) message.id: message
        };

        List<ChatMessage> mergedMessages = newGroup.messages.fold<Map<String, ChatMessage>>(messageMap, (map, message) {
          ChatMessage? existingMessage = map[message.id];

          if(existingMessage != null) {
            map[message.id] = message;
          } else {
            map[message.id] = message;
          }

          return map;
        }).values.toList();
        mergedMessages.sort((a, b) => a.sentAt.compareTo(b.sentAt));

        map[newGroup.label] = existingGroup.copyWith(messages: mergedMessages);
      } else {
        map[newGroup.label] = newGroup;
      }

      return map;
    });
  }

  @override
  void onReady() {
    messageScrollController.addListener(_onScrollListener);

    focusNode.addListener(() {
      if(focusNode.hasFocus) {
        _scrollToLastMessage();
      }
    });

    textMessage.addListener(() {
      typingController.notify(textMessage.text);

      if(textMessage.text.isNotEmpty) {
        state.showSendButton.value = true;
      }
    });

    super.onReady();
  }

  void _onScrollListener() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if(messageScrollController.position.pixels == messageScrollController.position.minScrollExtent) {
        state.showScrollButton.value = false;
      } else if(messageScrollController.position.extentBefore < 100) {
        state.showScrollButton.value = false;
      } else {
        state.showScrollButton.value = true;
      }
    });

    if (messageScrollController.position.atEdge && messageScrollController.position.pixels == messageScrollController.position.maxScrollExtent) {
      // Fetch older messages when scrolled to the top
      if(state.isLastPage.isFalse) {
        state.isLoadingMore.value = true;
        _fetchMessages();
      }
    }
  }

  @override
  void onClose() {
    textMessage.dispose();
    _debounceTimer?.cancel();
    typingController.close();
    _socket.disconnect();
    messageScrollController.removeListener(_onScrollListener);

    super.onClose();
  }

  /// Checks if the message container should be nipped or not
  bool shouldNip(int index, List<ChatMessage> messages) =>
      (index == 0) || (index > 0 && messages[index].isSentByCurrentUser != messages[index - 1].isSentByCurrentUser);

  /// Mark message as read
  void markRead(ChatMessage message) {
    if(_socket.isConnected) {
      if(message.status.toLowerCase() != "read" && !message.isSentByCurrentUser) {
        Map<String, dynamic> update = {
          "room": state.room.value,
          "id": message.id,
          "status": "READ",
        };
        _socket.send(destination: "/chat/update", message: update);
      }
    }
  }

  void pickGallery(BuildContext context) {
    MediaSelector.open(
      onReceived: (result) {
        Navigate.back();
        state.media.value = result;
        send(context);
      },
      title: "Send an image",
      route: "/conversation/chat?roommate=${state.roommate.value}&room=${state.room.value}/gallery"
    );
  }

  void bookmark() {
    removeFocus();
    _bookmark();
  }

  void _bookmark () async {
    state.chatRoom.value = state.chatRoom.value.copyWith(isBookmarking: true);

    if(state.chatRoom.value.isBookmarked) {
      var response = await _connect.delete(endpoint: "/bookmark/remove?id=${state.chatRoom.value.bookmark}");
      state.chatRoom.value = state.chatRoom.value.copyWith(isBookmarking: false);

      if(response.isOk) {
        state.chatRoom.value = state.chatRoom.value.copyWith(isBookmarked: false);
        _socket.send(destination: "/chat/refresh", message: { "room": state.room.value });
        notify.success(message: response.message);
      } else {
        notify.error(message: response.message);
      }
    } else {
      var response = await _connect.post(endpoint: "/bookmark/add", body: {"user": state.roommate.value});
      state.chatRoom.value = state.chatRoom.value.copyWith(isBookmarking: false);

      if(response.isOk) {
        state.chatRoom.value = state.chatRoom.value.copyWith(isBookmarked: true, bookmark: response.data);
        _socket.send(destination: "/chat/refresh", message: { "room": state.room.value });
        notify.success(message: response.message);
      } else {
        notify.error(message: response.message);
      }
    }
  }

  void schedule() {
    removeFocus();
    _schedule();
  }

  void _schedule() async {
    if(state.chatRoom.value.isScheduled) {
      ActivityScheduleAction.open(
        schedule: state.chatRoom.value.schedule,
        onCancelled: () {
          state.chatRoom.value = state.chatRoom.value.copyWith(schedule: Schedule.empty());
          _socket.send(destination: "/chat/refresh", message: { "room": state.room.value });
          Navigate.back();
        },
      );
    } else {
      ScheduleTimePicker.open(
        id: state.roommate.value,
        name: state.chatRoom.value.name,
        onSchedule: (schedule) {
          state.chatRoom.value = state.chatRoom.value.copyWith(schedule: schedule);
          _socket.send(destination: "/chat/refresh", message: { "room": state.room.value });
        }
      );
    }
  }

  void openOption() {
    removeFocus();
    ChatRoomOptionSheet.open(room: state.chatRoom.value);
  }

  /// Select a message for more actions
  void selectMessage(ChatMessage message) {
    removeFocus();

    if(state.openMessage.value.id != message.id) {
      state.openMessage.value = message;
    }
  }

  /// Remove focus from text form field
  void removeFocus() {
    if(focusNode.hasFocus) {
      focusNode.unfocus();
    }
  }

  /// Unselect a message or tap to view more details about the message
  void unselectMessage(ChatMessage message) {
    removeFocus();

    if(state.openMessage.value.id == message.id) {
      state.openMessage.value = ChatMessage.empty();
    } else {
      ChatRoomMessageDetail.open(message: message);
    }
  }

  void toggleEmojiKeyboard() {
    if (state.emojiShowing.value) {
      state.emojiShowing.value = false;
      focusNode.requestFocus();
    } else {
      focusNode.unfocus();
      state.emojiShowing.value = true;
    }
  }

  /// Action to do when the logged in user swipes its message
  void onMyMessageSwipe(ChatMessage message) {
    if(message.isSentByCurrentUser) {
      swipeMessage(message);
    }
  }

  /// Swipe message action
  void swipeMessage(ChatMessage message) {
    state.isSwiped.value = true;
    state.reply.value = ChatReply(
      id: message.id,
      label: message.label,
      message: message.message,
      status: message.status,
      fileSize: message.fileSize,
      type: message.type,
      sender: message.name,
      duration: message.duration,
      isSentByCurrentUser: message.isSentByCurrentUser
    );
  }

  /// Action to perform when logged in user swipes another message not sent by the user
  void onOtherMessageSwipe(ChatMessage message) {
    if(!message.isSentByCurrentUser) {
      swipeMessage(message);
    }
  }

  /// Cancel a message that has been selected for a reply
  void cancelReplyMessage() {
    state.isSwiped.value = false;
    state.reply.value = ChatReply.empty();
    state.isSwiped.refresh();
    state.reply.refresh();
  }

  /// Scroll to a replied message
  void scrollToMessage(ChatReply reply, ChatMessage message) {
    int position = _getReplyLocation(reply.id);
    if (position != -1 && messageHeights.containsKey(reply.id)) {
      double scrollPosition = 0;

      // Calculate scroll position based on the heights of previous messages
      for (var key in messageHeights.keys) {
        if (key == reply.id) break;
        scrollPosition += messageHeights[key]!;
      }

      // Ensure scrollPosition is within bounds
      final maxScrollExtent = messageScrollController.position.maxScrollExtent;
      scrollPosition = scrollPosition.clamp(0.0, maxScrollExtent);

      messageScrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
      );

      state.selectedMessageId.value = reply.id;
      ChatRoomMessageDetail.open(reply: reply, message: message);

      Future.delayed(const Duration(seconds: 4), () {
        state.selectedMessageId.value = "";
      });
    }
  }

  /// Get the reply location of a message
  int _getReplyLocation(String id) {
    return state.chatRoom.value.groups.expand((g) => g.messages).toList().indexWhere((element) {
      return element.id == id;
    });
  }

  /// Update message content height
  void updateMessageHeight(String id, double height) {
    if(messageHeights.containsKey(id)) {
      messageHeights[id] = height;
    } else {
      messageHeights.putIfAbsent(id, () => height);
    }
  }

  /// Send a message
  void send(BuildContext context) {
    if(_socket.isConnected) {
      if(textMessage.text.isNotEmpty || state.media.value.path.isNotEmpty) {
        String type = state.media.value.path.isNotEmpty
            ? "IMAGE"
            : CommonUtility.hasEmojis(textMessage.text.trim()) || CommonUtility.containsOnlyEmojis(textMessage.text.trim())
            ? "EMOJI"
            : "TEXT";

        Map<String, dynamic> message = {
          "room": state.room.value,
          "type": type,
        };

        if(state.media.value.path.isNotEmpty) {
          message.update("file", (value) => {
            "path": state.media.value.path,
            "bytes": state.media.value.data,
            "media": state.media.value.media.type
          }, ifAbsent: () => {
            "path": state.media.value.path,
            "bytes": state.media.value.data,
            "media": state.media.value.media.type
          });
          message.update("duration", (value) => state.media.value.duration, ifAbsent: () => state.media.value.duration);

          ChatMessage chat = ChatMessage.sending(
            message: state.media.value.path,
            type: "IMAGE",
            fileSize: state.media.value.size
          );

          _addNewChat(message, chat);
          _send(message, context);
        } else {
          String encryptedMessage = _e2eeService.encrypt(
            message: textMessage.text.trim(),
            recipientPublicKey: state.chatRoom.value.publicEncryptionKey
          );
          String senderMessage = _e2eeService.encrypt(
            message: textMessage.text.trim(),
            recipientPublicKey: Database.e2ee.publicKey
          );

          if(encryptedMessage.isNotEmpty && senderMessage.isNotEmpty) {
            message.update("message", (value) => encryptedMessage, ifAbsent: () => encryptedMessage);
            message.update("sender_message", (value) => senderMessage, ifAbsent: () => senderMessage);

            ChatMessage chat = ChatMessage.sending(message: senderMessage);
            _addNewChat(message, chat);

            textMessage.text = "";
            _send(message, context);
          } else {
            notify.tip(message: "An error occurred while trying to send message. Try again", color: CommonColors.error);
          }
        }
      } else {
        return;
      }
    } else {
      notify.tip(message: "Network error");
    }
  }

  /// Add dummy message to list before sending it
  void _addNewChat(Map<String, dynamic> message, ChatMessage chat) {
    if(state.reply.value.id.isNotEmpty) {
      message.putIfAbsent("replied", () => state.reply.value.id);
      chat = chat.copyWith(reply: state.reply.value);
    }

    _updateMessage(chat);
    scrollToEnd();
  }

  void _updateMessage(ChatMessage chat) {
    if (state.chatRoom.value.groups.isNotEmpty) {
      // Create a list of messages from the last chat group and add the new message
      List<ChatMessage> messages = List.from(state.chatRoom.value.groups.last.messages);
      messages.add(chat);

      // Create a new ChatGroupMessage with the updated messages
      ChatGroupMessage updatedGroup = state.chatRoom.value.groups.last.copyWith(messages: messages);

      // Replace the last group with the updated group and update the chat room's state
      List<ChatGroupMessage> updatedGroups = List.from(state.chatRoom.value.groups);
      updatedGroups[updatedGroups.length - 1] = updatedGroup;

      state.chatRoom.value = state.chatRoom.value.copyWith(groups: updatedGroups);
      _updateMessageList(state.chatRoom.value.groups);
    } else {
      // Create a new ChatGroupMessage since there are no existing groups
      ChatGroupMessage newGroup = ChatGroupMessage(
        label: _formatChatLabel(),
        time: DateTime.now(),
        messages: [chat]
      );

      // Update the chat room's state with the new group
      state.chatRoom.value = state.chatRoom.value.copyWith(groups: [newGroup]);
      _updateMessageList(state.chatRoom.value.groups);
    }
  }

  /// Format a group message label while dumbing the data
  String _formatChatLabel() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final lastWeek = today.subtract(const Duration(days: 7));

    if (today.isAtSameMomentAs(now)) {
      return "Today";
    } else if (now.isAtSameMomentAs(yesterday)) {
      return 'Yesterday';
    } else if (now.isAfter(lastWeek)) {
      final weekdayNames = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      final weekdayIndex = now.weekday - 1;
      return weekdayNames[weekdayIndex];
    } else {
      final formatter = DateFormat('EEEE MMMM d, y');
      return formatter.format(now);
    }
  }

  /// Send message implementation
  void _send(Map<String, dynamic> message, BuildContext context) {
    state.reply.value = ChatReply.empty();
    state.isSwiped.value = false;
    _socket.send(destination: "/chat/send", message: message);

    state.showSendButton.value = false;
    typingController.notify("");
  }
}