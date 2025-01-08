import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:user/library.dart';

class BookmarkController extends GetxController {
  BookmarkController();
  static BookmarkController get data => Get.find<BookmarkController>();

  final state = BookmarkState();

  final ConnectService _connect = Connect();

  final _pageSize = 20;
  final PagingController<int, Bookmark> bookmarkController = PagingController(firstPageKey: 0);

  @override
  void onInit() {
    bookmarkController.addPageRequestListener((page) {
      _fetch(page);
    });

    super.onInit();
  }

  void _fetch(int page) async {
    var response = await _connect.get(endpoint: "/bookmark?page=$page&size=$_pageSize");

    if(response.isOk) {
      List<dynamic> result = response.data;
      List<Bookmark> bookmarks = result.map((e) => Bookmark.fromJson(e)).toList();

      bool isLast = bookmarks.length < _pageSize;
      if(isLast) {
        bookmarkController.appendLastPage(bookmarks);
      } else {
        bookmarkController.appendPage(bookmarks, CommonUtility.increment(page));
      }
    } else {
      notify.error(message: response.message);
    }
  }

  void stopShowingBookmark() {
    Database.saveNotifier(Database.notifier.copyWith(showBookmark: false));
    state.showBookmark.value = false;
  }

  @override
  void onClose() {
    bookmarkController.dispose();

    super.onClose();
  }
}