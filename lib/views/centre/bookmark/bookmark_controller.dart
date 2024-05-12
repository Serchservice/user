import 'package:get/get.dart';
import 'package:user/library.dart';

class BookmarkController extends GetxController {
  BookmarkController();
  final state = BookmarkState();

  final Connect _connect = Connect();

  @override
  void onInit() {
    fetchBookmarks();
    super.onInit();
  }

  void fetchBookmarks () async {
    state.isFetching.value = true;
    try {
      var res = await _connect.get(endpoint: "/bookmark/all");
      ApiResponse response = ApiResponse.fromJson(res.data);
      state.isFetching.value = false;
      if(response.isOk) {
        List<dynamic> result = response.data;
        List<Bookmark> bookmarks = result.map((e) => Bookmark.fromJson(e)).toList();
        state.bookmarks.value = bookmarks;
      } else {
        SnackBars.top(message: response.message, type: Snackbar.error);
      }
    } on Exception catch (e) {
      Connect.showError(e);
    }
  }

  void stopShowingBookmark() {
    Database.saveNotifier(Database.notifier.copyWith(showBookmark: false));
    state.showBookmark.value = false;
  }
}