import 'package:get/get.dart';
import 'package:user/library.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SharedLinksController extends GetxController {
  SharedLinksController();
  static SharedLinksController get data => Get.find<SharedLinksController>();

  final state = SharedLinksState();

  final ConnectService _connect = Connect();

  final _pageSize = 20;
  final PagingController<int, SharedLink> sharedController = PagingController(firstPageKey: 0);

  @override
  void onInit() {
    sharedController.addPageRequestListener((page) {
      _fetch(page);
    });

    super.onInit();
  }

  void _fetch(int page) async {
    var response = await _connect.get(endpoint: "/guest/shared/links?page=$page&size=$_pageSize");

    if(response.isOk) {
      List<dynamic> result = response.data;
      List<SharedLink> links = result.map((e) => SharedLink.fromJson(e)).toList();

      bool isLast = links.length < _pageSize;
      if(isLast) {
        sharedController.appendLastPage(links);
      } else {
        sharedController.appendPage(links, CommonUtility.increment(page));
      }
    } else {
      sharedController.error = response.message;
    }
  }

  void stopShowingSharedLinks() {
    Database.saveNotifier(Database.notifier.copyWith(showSharedLinks: false));
    state.showSharedLinks.value = false;
  }

  @override
  void onClose() {
    sharedController.dispose();

    super.onClose();
  }
}