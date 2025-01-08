import 'package:get/get.dart';
import 'package:user/library.dart';

class BookmarkState {
  /// Show bookmark info
  RxBool showBookmark = RxBool(Database.notifier.showBookmark);
}