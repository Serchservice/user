import 'package:user/library.dart';
import 'package:connectify_flutter/connectify_flutter.dart';

class HomeMessaging implements HomeMessagingService {
  final HomeController controller;
  HomeMessaging({required this.controller});

  final ConnectService _connect = Connect();

  @override
  List<ButtonView> get filters => [
    ButtonView(header: "All", index: 0),
    ButtonView(header: "Unread", index: 1),
  ];

  @override
  void prepareData({required Map<String, dynamic> data}) {
    ChatRoom room = ChatRoom.fromJson(data);
    if (room.status.toLowerCase() == "sent") {
      Map<String, dynamic> update = {
        "room": room.room,
        "id": room.messageId,
        "status": "DELIVERED",
      };
      socket.send(destination: "/chat/update", message: update);
    }
    updateChats(room);
    subscribeToChatRooms();
  }

  @override
  void fetchChats({bool showLoader = true}) async {
    if(showLoader) {
      controller.state.isFetchingChats.value = true;
    }
    var response = await _connect.get(endpoint: "/chat/rooms");
    if(response.isOk) {
      controller.state.isFetchingChats.value = false;
      List<dynamic> data = response.data;
      List<ChatRoom> chats = data.map((e) => ChatRoom.fromJson(e)).toList();
      controller.state.chats.value = chats;
      subscribeToChatRooms();
      controller.state.filteredChats.value = chats;
    } else {
      notify.error(message: response.message);
    }
  }

  @override
  void filterChats(int index) {
    controller.state.currentChatFilter.value = index;
    controller.state.filteredChats.value = controller.state.chats;
    if(index == 0) {
      return;
    } else {
      controller.state.filteredChats.value = controller.state.filteredChats.where((chat) {
        return chat.count > 0;
      }).toList();
    }
  }

  @override
  void loadSpeakWithSerchMessages() async {
    var response = await _connect.get(endpoint: "/company/speak_with_serch");
    if(response.isOk) {
      updateSpeakWithSerch(response);
    }
  }

  @override
  void subscribeToChatRooms() {
    for(var chat in controller.state.chats) {
      if(!controller.state.subscribed.contains(chat.room)) {
        if(socket.isConnected) {
          socket.send(
              destination: "/chat/connect",
              message: { "room": chat.room }
          );
        }
        controller.state.subscribed.add(chat.room);
      }
    }
  }

  @override
  void updateChats(ChatRoom room) {
    List<ChatRoom> chats = List.from(controller.state.chats); // Create a copy to avoid modifying the controller.state directly
    // Find the index of the existing room
    int existingIndex = chats.indexWhere((existingRoom) => existingRoom.room == room.room);

    if (existingIndex != -1) {
      // If the room exists, update the existing room
      chats[existingIndex] = room;
    } else {
      // If the room does not exist, add the new room
      chats.add(room);
    }

    // Sort the list based on `sentAt`
    chats.sort((a, b) => b.sentAt.compareTo(a.sentAt));
    // Update the controller.state with the new list
    controller.state.chats.value = chats;
    // Apply the current filter
    filterChats(controller.state.currentChatFilter.value);
  }

  @override
  void updateSpeakWithSerch(ApiResponse<dynamic> response) {
    List<dynamic> result = response.data;
    List<SpeakWithSerch> speakWithSerch = result.map((e) => SpeakWithSerch.fromJson(e)).toList();
    controller.state.speakWithSerch.value = speakWithSerch;
    controller.state.hasSerchMessage.value = speakWithSerch.any((element) {
      return element.issues.isNotEmpty && element.issues.any((element) => !element.isRead);
    });
  }
}