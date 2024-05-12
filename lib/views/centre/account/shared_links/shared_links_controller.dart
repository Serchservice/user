import 'package:get/get.dart';
import 'package:user/library.dart';

class SharedLinksController extends GetxController {
  SharedLinksController();
  final state = SharedLinksState();

  final Connect _connect = Connect();

  @override
  void onInit() {
    fetch();
    super.onInit();
  }

  void fetch() async {
    state.isFetching.value = true;
    try {
      var res = await _connect.get(endpoint: "/guest/shared/links");
      ApiResponse response = ApiResponse.fromJson(res.data);
      state.isFetching.value = false;
      if(response.isOk) {
        List<dynamic> result = response.data;
        List<SharedLink> links = result.map((e) => SharedLink.fromJson(e)).toList();
        state.links.value = links;
      }
    } on Exception catch(e) {
      Connect.showError(e);
    }
  }

  void stopShowingSharedLinks() {
    Database.saveNotifier(Database.notifier.copyWith(showSharedLinks: false));
    state.showSharedLinks.value = false;
  }
}