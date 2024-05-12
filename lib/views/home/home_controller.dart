import 'package:get/get.dart';
import 'package:user/library.dart';

class HomeController extends GetxController {
  HomeController();
  final state = HomeState();

  final CommonApiService _apiService = CommonApi();
  final Connect _connect = Connect();

  @override
  void onInit() {
    _apiService.fetchAccounts();
    loadSpeakWithSerchMessages();
    super.onInit();
  }

  @override
  void onReady() {
    CommonUtility.fetch(
      action: () => loadSpeakWithSerchMessages(),
      durationInSeconds: 60
    );
    super.onReady();
  }

  void selectRoute(int index) {
    state.routeIndex.value = index;
    update();
  }

  void loadSpeakWithSerchMessages() async {
    try {
      var res = await _connect.get(endpoint: "/company/speak_with_serch");
      ApiResponse response = ApiResponse.fromJson(res.data);
      if(response.isOk) {
        updateSpeakWithSerch(response);
      }
    } on Exception catch(_) { }
  }

  void updateSpeakWithSerch(ApiResponse<dynamic> response) {
    List<dynamic> result = response.data;
    List<SpeakWithSerch> speakWithSerch = result.map((e) => SpeakWithSerch.fromJson(e)).toList();
    state.speakWithSerch.value = speakWithSerch;
    state.hasSerchMessage.value = speakWithSerch.any((element) {
      return element.issues.isNotEmpty && element.issues.any((element) => !element.isRead);
    });
  }
}