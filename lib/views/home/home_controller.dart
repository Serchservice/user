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
    loadCategories();
    loadPopularCategories();
    fetchDashboard(true);
    super.onInit();
  }

  @override
  void onReady() {
    CommonUtility.fetch(
      action: () {
        loadSpeakWithSerchMessages();
        fetchDashboard(false);
        _apiService.fetchAccounts();
      },
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

  void loadCategories() async {
    state.isFetchingCategories.value = true;
    try {
      var res = await _connect.get(endpoint: "/category/all");
      ApiResponse response = ApiResponse.fromJson(res.data);
      if(response.isOk) {
        state.isFetchingCategories.value = false;
        List<dynamic> data = response.data;
        List<SerchCategory> categories = data.map((e) => SerchCategory.fromJson(e)).toList();
        state.categories.value = categories;
      } else {
        SnackBars.top(message: response.message, type: Snackbar.error);
      }
    } on Exception catch(e) {
      Connect.showError(e);
    }
  }

  void loadPopularCategories() async {
    state.isFetchingPopularCategories.value = true;
    try {
      var res = await _connect.get(endpoint: "/category/popular");
      ApiResponse response = ApiResponse.fromJson(res.data);
      if(response.isOk) {
        state.isFetchingPopularCategories.value = false;
        List<dynamic> data = response.data;
        List<SerchCategory> popularCategories = data.map((e) => SerchCategory.fromJson(e)).toList();
        state.popularCategories.value = popularCategories;
      } else {
        SnackBars.top(message: response.message, type: Snackbar.error);
      }
    } on Exception catch(e) {
      Connect.showError(e);
    }
  }

  void fetchDashboard(bool showLoader) async {
    if(showLoader) {
      state.isFetchingDashboard.value = true;
    }
    try {
      var res = await _connect.get(endpoint: "/account/dashboard");
      ApiResponse response = ApiResponse.fromJson(res.data);
      if(response.isOk) {
        state.isFetchingDashboard.value = false;
        Dashboard dashboard = Dashboard.fromJson(response.data);
        state.dashboard.value = dashboard;
      } else {
        SnackBars.top(message: response.message, type: Snackbar.error);
      }
    } on Exception catch(e) {
      Connect.showError(e);
    }
  }
}