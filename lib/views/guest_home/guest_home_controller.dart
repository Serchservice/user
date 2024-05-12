import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestHomeController extends GetxController {
  GuestHomeController();
  final state = GuestHomeState();
  final CommonApiService _apiService = CommonApi();

  @override
  void onInit() {
    _apiService.fetchAccounts();
    super.onInit();
  }

  void selectRoute(int index) {
    state.routeIndex.value = index;
    update();
  }
}