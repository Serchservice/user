import 'package:get/get.dart';
import 'package:user/library.dart';

class BookmarkController extends GetxController {
  BookmarkController();
  final state = BookmarkState();
  final HomeController home = HomeController.data;

  final ConnectService _connect = Connect();

  @override
  void onInit() {
    fetchBookmarks();
    super.onInit();
  }

  void fetchBookmarks () async {
    state.isFetching.value = true;
    var response = await _connect.get(endpoint: "/bookmark/all");
    state.isFetching.value = false;
    if(response.isOk) {
      List<dynamic> result = response.data;
      List<Bookmark> bookmarks = result.map((e) => Bookmark.fromJson(e)).toList();
      state.bookmarks.value = bookmarks;
    } else {
      notify.error(message: response.message);
    }
  }

  void stopShowingBookmark() {
    Database.saveNotifier(Database.notifier.copyWith(showBookmark: false));
    state.showBookmark.value = false;
  }
}