import 'package:user/library.dart';

class HomeSharedLink implements HomeSharedLinkService {
  final HomeController controller;
  HomeSharedLink({required this.controller});

  final ConnectService _connect = Connect();

  @override
  void addToLinks(SharedLink link) {
    List<SharedLink> links = controller.state.sharedLinks;
    int index = links.indexOf(link);

    if(index != -1) {
      links[index] = link;
    } else {
      links.add(link);
    }

    controller.state.sharedLinks.value = links;
  }

  @override
  void fetch({bool showLoader = true}) async {
    if(showLoader) {
      controller.state.isFetchingSharedLinks.value = true;
    }

    var response = await _connect.get(endpoint: "/guest/shared/links");
    controller.state.isFetchingSharedLinks.value = false;
    if(response.isOk) {
      List<dynamic> result = response.data;
      List<SharedLink> links = result.map((e) => SharedLink.fromJson(e)).toList();
      controller.state.sharedLinks.value = links;
    }
  }

  @override
  void updateList(List<dynamic> data) {
    List<SharedLink> links = data.map((d) => SharedLink.fromJson(d)).toList();
    controller.state.sharedLinks.value = links;
  }
}