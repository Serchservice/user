import 'package:user/library.dart';
import 'package:connectify_flutter/connectify_flutter.dart';

/// Abstract service for managing home messaging functionality, including filters and chat operations.
abstract class HomeMessagingService {

  /// Gets the list of filter buttons.
  ///
  /// @return A [List] of [ButtonView] objects representing the available filters.
  List<ButtonView> get filters;

  /// Loads messages for the "Speak with Serch" feature.
  void loadSpeakWithSerchMessages();

  /// Updates the "Speak with Serch" messages based on the provided response.
  ///
  /// @param response The [ApiResponse] containing the updated data.
  void updateSpeakWithSerch(ApiResponse<dynamic> response);

  /// Fetches the list of chats.
  ///
  /// @param showLoader Indicates if a loader should be shown while fetching the chats. Defaults to true.
  void fetchChats({bool showLoader = true});

  /// Subscribes to chat rooms for receiving messages.
  void subscribeToChatRooms();

  /// Filters the chats based on the given index.
  ///
  /// @param index The index of the filter to apply.
  void filterChats(int index);

  /// Updates the chat list with the provided chat room data.
  ///
  /// @param room The [ChatRoom] object containing the updated chat data.
  void updateChats(ChatRoom room);

  /// Prepares the data for messaging operations.
  ///
  /// @param data A [Map] containing the data to be prepared.
  void prepareData({required Map<String, dynamic> data});
}