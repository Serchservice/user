import 'package:user/library.dart';

class HomeDashboard implements HomeDashboardService {
  final HomeController controller;
  HomeDashboard({required this.controller});

  final ConnectService _connect = Connect();

  @override
  void fetchDashboard(bool showLoader) async {
    if(showLoader) {
      controller.state.isFetchingDashboard.value = true;
    }
    var response = await _connect.get(endpoint: "/account/dashboard");
    if(response.isOk) {
      controller.state.isFetchingDashboard.value = false;
      Dashboard dashboard = Dashboard.fromJson(response.data);
      controller.state.dashboard.value = dashboard;
    } else {
      notify.error(message: response.message);
    }
  }

  @override
  void loadCategories() async {
    controller.state.isFetchingCategories.value = true;
    var response = await _connect.get(endpoint: "/category/all");
    if(response.isOk) {
      controller.state.isFetchingCategories.value = false;
      List<dynamic> data = response.data;
      List<SerchCategory> categories = data.map((e) => SerchCategory.fromJson(e)).toList();
      controller.state.categories.value = categories;
    } else {
      notify.error(message: response.message);
    }
  }

  @override
  void loadPopularCategories() async {
    controller.state.isFetchingPopularCategories.value = true;
    var response = await _connect.get(endpoint: "/category/popular");
    if(response.isOk) {
      controller.state.isFetchingPopularCategories.value = false;
      List<dynamic> data = response.data;
      List<SerchCategory> popularCategories = data.map((e) => SerchCategory.fromJson(e)).toList();
      controller.state.popularCategories.value = popularCategories;
    } else {
      notify.error(message: response.message);
    }
  }

}