import 'package:user/library.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SpeakWithSerchController extends GetxController {
  SpeakWithSerchController();
  static SpeakWithSerchController get data => Get.find<SpeakWithSerchController>();

  final state = SpeakWithSerchState();

  final ConnectService _connect = Connect();
  final _pageSize = 20;
  final PagingController<int, SpeakWithSerch> messageController = PagingController(firstPageKey: 1);

  @override
  void onInit() {
    _fetch(0);
    messageController.addPageRequestListener(_fetch);

    super.onInit();
  }

  void _fetch(int page) async {
    var response = await _connect.get(endpoint: "/company/speak_with_serch?page=$page&size=$_pageSize");

    if(response.isOk) {
      List<dynamic> result = response.data;
      List<SpeakWithSerch> list = result.map((e) => SpeakWithSerch.fromJson(e)).toList();

      _updateHasMessage(list);

      if(list.length < _pageSize) {
        messageController.appendLastPage(list);
      } else {
        messageController.appendPage(list, CommonUtility.increment(page));
      }
    } else {
      messageController.error = response.message;
    }
  }

  void refreshList() {
    _fetch(0);
  }

  void updateList(List<SpeakWithSerch> list) {
    messageController.itemList = list;
    messageController.nextPageKey = 1;

    _updateHasMessage(list);
  }

  void _updateHasMessage(List<SpeakWithSerch> list) {
    state.hasSerchMessage.value = list.any((element) => element.hasSerchMessage);
  }

  @override
  void onClose() {
    messageController.dispose();

    super.onClose();
  }
}