import 'package:user/library.dart';

class HomeCall implements HomeCallService {
  final HomeController controller;
  HomeCall({required this.controller});

  final ConnectService _connect = Connect();

  @override
  void fetchCalls({bool showLoader = true}) async {
    if(showLoader) {
      controller.state.isFetchingCalls.value = true;
    }
    var response = await _connect.get(endpoint: "/call/history");
    if(response.isOk) {
      controller.state.isFetchingCalls.value = false;
      List<dynamic> data = response.data;
      List<CallResponse> calls = data.map((e) => CallResponse.fromJson(e)).toList();
      controller.state.calls.value = calls;
      controller.state.filteredCalls.value = calls;
    } else {
      notify.error(message: response.message);
    }
  }

  @override
  List<ButtonView> get filters => [
    ButtonView(header: "All", index: 0),
    ButtonView(header: "Missed", index: 1),
    ButtonView(header: "Outgoing", index: 2),
    ButtonView(header: "Incoming", index: 3),
    ButtonView(header: "Tip2Fix", index: 4),
  ];
}