import 'package:get/get.dart';
import 'package:user/library.dart';

class BookmarkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookmarkController>(() => BookmarkController());
  }
}