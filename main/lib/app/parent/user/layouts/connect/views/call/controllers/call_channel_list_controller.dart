import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:user/library.dart';

class CallChannelListController extends GetxController {
  CallChannelListController();
  static CallChannelListController get data => Get.find<CallChannelListController>();
  final state = CallChannelListState();

  final ConnectService _connect = Connect();

  final _pageSize = 20;
  final PagingController<int, CallResponse> callController = PagingController(firstPageKey: 0);

  @override
  void onInit() {
    callController.addPageRequestListener((page) => _fetch(page));

    super.onInit();
  }

  void _fetch(int page) async {
    var response = await _connect.get(endpoint: "/call/history?page=$page&size=$_pageSize");

    if(response.isOk) {
      List<dynamic> data = response.data;
      List<CallResponse> calls = data.map((e) => CallResponse.fromJson(e)).toList();
      _updateList(calls);

      if(calls.length < _pageSize) {
        callController.appendLastPage(calls);
      } else {
        callController.appendPage(calls, CommonUtility.increment(page));
      }

      filter(state.filter.value, state.filterString.value);
    } else {
      notify.error(message: response.message);
    }
  }

  void _updateList(List<CallResponse> calls) {
    List<CallResponse> list = List.from(state.calls);
    list.addAll(calls);

    state.calls.value = list;
  }

  List<ButtonView> filters = [
    ButtonView(header: "All", index: 0),
    ButtonView(header: "Missed", index: 1),
    ButtonView(header: "Outgoing", index: 2),
    ButtonView(header: "Incoming", index: 3),
    ButtonView(header: "Tip2Fix", index: 4),
  ];

  void filter(int index, String header) {
    state.filter.value = index;
    state.filterString.value = header;

    List<CallResponse> calls = List.from(state.calls);
    if(index == 0) {
      calls = state.calls;
    } else if(index == 1) {
      calls = calls.where((call) => call.history.any((h) => h.isMissed)).toList();
    } else if(index == 2) {
      calls = calls.where((call) => call.history.any((h) => h.outgoing)).toList();
    } else if(index == 3) {
      calls = calls.where((call) => !call.history.any((h) => h.outgoing)).toList();
    } else {
      calls = calls.where((call) => call.history.any((h) => h.isT2F)).toList();
    }

    callController.itemList = calls;
  }

  @override
  void onClose() {
    callController.dispose();

    super.onClose();
  }
}