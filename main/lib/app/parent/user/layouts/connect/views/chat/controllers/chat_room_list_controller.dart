import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:user/library.dart';

class ChatRoomListController extends GetxController {
  ChatRoomListController();
  static ChatRoomListController get data => Get.find<ChatRoomListController>();
  final state = ChatRoomListState();

  final ConnectService _connect = Connect();
  final Socket _socket = Socket();
  final Socket _socketPresence = Socket();

  static void bind() {
    try {
      if(!ChatRoomListController.data.initialized) {
        Get.put<ChatRoomListController>(ChatRoomListController());
      }
    } catch (_) {
      Get.put<ChatRoomListController>(ChatRoomListController());
    }
  }

  final _pageSize = 20;
  final PagingController<int, ChatRoom> roomController = PagingController(firstPageKey: 0);

  @override
  void onInit() {
    roomController.addPageRequestListener((page) => _fetch(page));

    super.onInit();
  }

  void _fetch(int page) async {
    var response = await _connect.get(endpoint: "/chat/rooms?page=$page&size=$_pageSize");

    if(response.isOk) {
      List<dynamic> data = response.data;
      List<ChatRoom> rooms = data.map((e) => ChatRoom.fromJson(e)).toList();
      _updateRooms(rooms);

      if(rooms.length < _pageSize) {
        roomController.appendLastPage(rooms);
      } else {
        roomController.appendPage(rooms, CommonUtility.increment(page));
      }

      filter(state.filter.value);
    } else {
      notify.error(message: response.message);
    }
  }

  void _updateRooms(List<ChatRoom> newRooms) {
    final existingIds = state.rooms.map((room) => room.room).toSet();
    List<ChatRoom> roomsToAdd = newRooms.where((room) => !existingIds.contains(room.room)).toList();

    List<ChatRoom> updatedRooms = List.from(state.rooms);
    for (var newRoom in newRooms) {
      final existingIndex = updatedRooms.indexWhere((room) => room.room == newRoom.room);
      if (existingIndex != -1) {
        updatedRooms[existingIndex] = newRoom;
      }
    }

    List<ChatRoom> allRooms = updatedRooms..addAll(roomsToAdd);
    allRooms.sort((a, b) => b.sentAt.compareTo(a.sentAt));
    state.rooms.value = allRooms;
  }

  @override
  void onReady() {
    _socket.initialize(
      callback: (frame) {
        if (frame.hasData) {
          List<dynamic> result = frame.data;
          List<ChatRoom> rooms = result.map((e) => ChatRoom.fromJson(e)).toList();

          _resetRooms(rooms);
        }
      },
      endpoint: "/ws:serch",
      subscribeDestination: "/platform/${Database.auth.id}/chat"
    );

    _socketPresence.initialize(
      callback: (frame) {
        if (frame.hasData) {
          notify.tip(message: frame.data, color: CommonColors.allday);
        }
      },
      endpoint: "/ws:serch",
      subscribeDestination: "/platform/${Database.auth.id}/chat/presence"
    );

    super.onReady();
  }

  void _resetRooms(List<ChatRoom> rooms) {
    if(rooms.isNotEmpty) {
      rooms.sort((a, b) => b.sentAt.compareTo(a.sentAt));
      state.rooms.value = rooms;

      roomController.itemList = rooms;
      roomController.nextPageKey = 1;

      filter(state.filter.value);
    }
  }

  List<ButtonView> filters = [
    ButtonView(header: "All", index: 0),
    ButtonView(header: "Unread", index: 1),
  ];

  void filter(int index) {
    state.filter.value = index;
    state.filterString.value = filters[index].header;

    List<ChatRoom> rooms;
    
    if(index == 0) {
      rooms = List.from(state.rooms);
    } else {
      rooms = state.rooms.where((chat) => chat.count > 0).toList();
    }
    
    roomController.itemList = rooms;
  }

  /// Mark all messages as read
  void markAllUnreadMessagesAsRead(String room) {
    _socket.send(destination: "/chat/$room/mark/read");
  }

  @override
  void onClose() {
    roomController.dispose();
    _socket.disconnect();
    _socketPresence.disconnect();

    super.onClose();
  }
}