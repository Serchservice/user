import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:user/library.dart';

class ChatController extends GetxController {
  ChatController();
  final state = ChatState();
  final HomeController _home = HomeController.data;

  final param = Get.parameters;
  final args = Get.arguments;

  final ConnectService _connect = Connect();
  final SocketService _socket = Socket.instance;

  ScrollController messageScrollController = ScrollController();
  final TextEditingController textMessage = TextEditingController();
  FocusNode focusNode = FocusNode();

  final messageHeights = <String, double>{};

  Timer? _debounceTimer;

  @override
  void onInit() {
    if(args != null && args["room"] != null) {
      state.chatRoom.value = ChatRoom.fromJson(args["room"]);
    }

    if(args != null && args["data"] != null) {
      state.args.value = args["data"] ?? Object();
    }

    state.room.value = param["room"] ?? "";
    state.roommate.value = param["roommate"] ?? "";

    super.onInit();
  }

  @override
  void onReady() {
    if(state.chatRoom.value.room.isNotEmpty) {
      _scrollToLastMessage();
      _initSocket(state.chatRoom.value.room);
    } else if(state.room.value.isNotEmpty) {
      _getRoom().then((room) {
        if(room.isNotEmpty) {
          _initSocket(room);
        }
      });
    } else if(state.roommate.value.isNotEmpty) {
      _getOrCreateRoom().then((room) {
        if(room.isNotEmpty) {
          _initSocket(room);
        }
      });
    } else {
      notify.error(message: "Access denied. Cannot start chat");
      return;
    }

    messageScrollController.addListener(_onScrollListener);

    focusNode.addListener(() {
      if(focusNode.hasFocus) {
        _scrollToLastMessage();
      }
    });

    textMessage.addListener(() {
      if(textMessage.text.isNotEmpty) {
        state.showSendButton.value = true;
      }
    });
    super.onReady();
  }

  /// Initialize chat socket
  void _initSocket(String room) {
    state.room.value = room;
    _socket.initialize(
      callback: (frame) {
        if(frame.body != null) {
          ChatRoom room = ChatRoom.fromJson(jsonDecode(frame.body!));
          state.chatRoom.value = room;
          _scrollToLastMessage();

          _home.messaging.updateChats(room);
          _home.messaging.subscribeToChatRooms();
        }
      },
      endpoint: "/ws:serch",
      subscribeDestination: "/platform/$room/${Database.auth.id}"
    );
  }

  @override
  void onClose() {
    textMessage.dispose();
    _debounceTimer?.cancel();
    messageScrollController.removeListener(_onScrollListener);
    super.onClose();
  }

  /// Get the room details if the room id was passed in the parameters
  Future<String> _getRoom() async {
    state.isFetchingData.value = true;
    var response = await _connect.get(endpoint: "/chat/room/${state.room.value}");
    if(response.isOk) {
      ChatRoom room = ChatRoom.fromJson(response.data);
      state.chatRoom.value = room;
      state.isFetchingData.value = false;
      return room.room;
    } else {
      notify.error(message: response.message);
      return "";
    }
  }

  /// Get the room id or create one {For a user only} with the roommate id passed in the parameter
  Future<String> _getOrCreateRoom() async {
    state.isFetchingData.value = true;
    var response = await _connect.get(endpoint: "/chat/room?roommate=${state.roommate.value}");
    if(response.isOk) {
      ChatRoom room = ChatRoom.fromJson(response.data);
      state.chatRoom.value = room;
      state.isFetchingData.value = false;
      return room.room;
    } else {
      notify.error(message: response.message);
      return "";
    }
  }

  /// Select a message for more actions
  void selectMessage(ChatMessage message) {
    removeFocus();
    if(state.openMessage.value.id != message.id) {
      state.openMessage.value = message;
    }
  }

  /// Unselect a message or tap to view more details about the message
  void unselectMessage(ChatMessage message) {
    removeFocus();
    if(state.openMessage.value.id == message.id) {
      state.openMessage.value = ChatMessage.empty();
    } else {
      MessageInformation.open(message: message, controller: this);
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
      hasOnlyEmojis: message.hasOnlyEmojis,
      hasOnlyOneEmoji: message.hasOnlyOneEmoji,
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

  /// Get the reply location of a message
  int _getReplyLocation(String id) {
    return state.chatRoom.value.groups.expand((g) => g.messages).toList().indexWhere((element) {
      return element.id == id;
    });
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
      MessageInformation.showReply(reply: reply, message: message, controller: this);

      Future.delayed(const Duration(seconds: 4), () {
        state.selectedMessageId.value = "";
      });
    }
  }

  /// Update message content height
  void updateMessageHeight(String id, double height) {
    if(messageHeights.containsKey(id)) {
      messageHeights[id] = height;
    } else {
      messageHeights.putIfAbsent(id, () => height);
    }
  }

  /// Scroll to the end of the chatting list
  void scrollToEnd() {
    if(messageScrollController.hasClients && messageScrollController.positions.isNotEmpty) {
      double height = messageHeights.isNotEmpty ? messageHeights.values.last : 60;

      messageScrollController.animateTo(
        messageScrollController.position.maxScrollExtent + height,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInCubic,
      );
    }
  }

  void _scrollToLastMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToEnd();
    });
  }

  void _onScrollListener() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (messageScrollController.position.pixels == messageScrollController.position.maxScrollExtent) {
        state.showScrollButton.value = false;
      } else if (messageScrollController.position.extentAfter < 100) {
        state.showScrollButton.value = false;
      } else {
        state.showScrollButton.value = true;
      }
    });
  }

  /// Send a message
  void send(BuildContext context) {
    if(_socket.stompClient.connected) {
      if(textMessage.text.isNotEmpty || state.media.value.path.isNotEmpty) {
        Map<String, dynamic> message = {
          "room": state.room.value,
          "message": textMessage.text.trim(),
          "type": "TEXT",
        };

        if(state.media.value.path.isNotEmpty) {
          message.update(
            "file",
            (value) => {
              "path": state.media.value.path,
              "bytes": state.media.value.data,
              "media": state.media.value.media.type
            },
            ifAbsent: () => {
              "path": state.media.value.path,
              "bytes": state.media.value.data,
              "media": state.media.value.media.type
            }
          );
          message.update("type", (value) => "IMAGE", ifAbsent: () => "IMAGE");
          message.update("duration", (value) => state.media.value.duration, ifAbsent: () => state.media.value.duration);
          message.update("message", (value) => "");

          ChatMessage chat = ChatMessage.sending(
            message: state.media.value.path,
            type: "IMAGE",
            fileSize: state.media.value.size
          );
          _addNewChat(message, chat);
          _send(message, context);
        } else {
          ChatMessage chat = ChatMessage.sending(message: textMessage.text.trim());
          _addNewChat(message, chat);
          textMessage.text = "";
          _send(message, context);
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
      chat.copyWith(reply: state.reply.value);
    }

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
    } else {
      // Create a new ChatGroupMessage since there are no existing groups
      ChatGroupMessage newGroup = ChatGroupMessage(
        label: _formatChatLabel(),
        time: DateTime.now(),
        messages: [chat]
      );

      // Update the chat room's state with the new group
      state.chatRoom.value = state.chatRoom.value.copyWith(groups: [newGroup]);
    }
    scrollToEnd();
  }

  /// Send message implementation
  void _send(Map<String, dynamic> message, BuildContext context) {
    state.reply.value = ChatReply.empty();
    state.isSwiped.value = false;
    _socket.send(destination: "/chat/send", message: message);
    state.showSendButton.value = false;
  }

  /// Checks if the message container should be nipped or not
  bool shouldNip(int index, List<ChatMessage> messages) =>
    (index == 0) || (index > 0 && messages[index].isSentByCurrentUser != messages[index - 1].isSentByCurrentUser);

  /// Format a group message label while dummying the data
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

  /// Remove focus from text form field
  void removeFocus() {
    if(focusNode.hasFocus) {
      focusNode.unfocus();
    }
  }

  /// Mark message as read
  void markRead(ChatMessage message) {
    if(_socket.stompClient.connected) {
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
    RouteNavigator.openMedia(
      onReceived: (result) {
        Navigate.back();
        state.media.value = result;
        send(context);
      },
      galleryParam: {
        "isVideo": "false",
        "title": "Send an image"
      },
      route: "/conversation/chat?roommate=${state.roommate.value}&room=${state.room.value}/gallery"
    );
  }

  void deleteMessage(ChatMessage message, BuildContext context) {
    if(_socket.stompClient.connected) {
      Map<String, dynamic> update = {
        "room": state.room.value,
        "id": message.id,
        "state": "DELETED",
      };
      _socket.send(destination: "/chat/update", message: update);
      Navigate.back();
    } else {
      notify.tip(message: "Network error");
    }
  }

  void bookmark () async {
    state.isBookmarking.value = true;
    if(state.chatRoom.value.isBookmarked) {
      var response = await _connect.delete(endpoint: "/bookmark/remove?id=${state.chatRoom.value.bookmark}");
      state.isBookmarking.value = false;
      if(response.isOk) {
        state.chatRoom.value = state.chatRoom.value.copyWith(isBookmarked: false);
        _socket.send(destination: "/chat/refresh", message: { "room": state.room.value });
        notify.success(message: response.message);
      } else {
        notify.error(message: response.message);
      }
    } else {
      var response = await _connect.post(endpoint: "/bookmark/add", body: {"user": state.roommate.value});
      state.isBookmarking.value = false;
      if(response.isOk) {
        state.chatRoom.value = state.chatRoom.value.copyWith(
            isBookmarked: true,
            bookmark: response.data
        );
        _socket.send(destination: "/chat/refresh", message: { "room": state.room.value });
        notify.success(message: response.message);
      } else {
        notify.error(message: response.message);
      }
    }
  }

  void schedule() async {
    if(state.chatRoom.value.isScheduled) {
      ScheduleTimeViewer.open(
        schedule: state.chatRoom.value.schedule,
        onCancel: () {
          state.chatRoom.value = state.chatRoom.value.copyWith(schedule: Schedule.empty());
          _home.messaging.updateChats(state.chatRoom.value);
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
}