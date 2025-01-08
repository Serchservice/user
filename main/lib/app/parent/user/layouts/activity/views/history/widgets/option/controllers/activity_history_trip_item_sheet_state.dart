import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class ActivityHistoryTripItemSheetState {
  /// Trip response data
  Rx<TripResponse> trip = TripResponse.empty().obs;

  /// Is sharing invited provider
  RxBool isSharingInvited = RxBool(false);

  /// Is bookmarking or removing bookmark for invited provider
  RxBool isBookmarkingInvited = RxBool(false);

  /// Is sharing provider
  RxBool isSharingProvider = RxBool(false);

  /// Is bookmarking or removing bookmark for provider
  RxBool isBookmarkingProvider = RxBool(false);
}