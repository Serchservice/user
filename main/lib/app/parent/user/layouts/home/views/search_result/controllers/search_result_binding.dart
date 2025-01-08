import 'package:get/get.dart';
import 'package:user/library.dart';

class SearchResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchResultController>(() => SearchResultController());
  }
}