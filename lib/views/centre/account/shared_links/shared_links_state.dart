import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class SharedLinksState {
  /// Is fetching
  RxBool isFetching = RxBool(true);

  /// List of SharedLinks
  RxList<SharedLink> links = <SharedLink>[].obs;

  /// Show link notification
  RxBool showSharedLinks = RxBool(Database.notifier.showSharedLinks);
}