import 'package:get/get.dart';
import 'package:user/library.dart';

class BookmarkState {
  /// Is fetching bookmarks
  RxBool isFetching = RxBool(true);

  /// List of bookmarks
  RxList<Bookmark> bookmarks = <Bookmark>[].obs;

  /// Show bookmark info
  RxBool showBookmark = RxBool(Database.notifier.showBookmark);
}