import 'package:user/library.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class RatingGoodTabController extends GetxController {
  RatingGoodTabController();
  final state = RatingGoodTabState();

  final ConnectService _connect = Connect();

  final _pageSize = 20;
  final PagingController<int, Rating> ratingController = PagingController(firstPageKey: 0);

  @override
  void onInit() {
    ratingController.addPageRequestListener((pageKey) {
      _fetchRating(pageKey);
    });

    super.onInit();
  }

  void _fetchRating(int pageKey) async {
    var response = await _connect.get(
        endpoint: "/rating/good?page=$pageKey&size=$_pageSize"
    );

    if(response.isOk) {
      List<dynamic> result = response.data;
      List<Rating> associates = result.map((e) => Rating.fromJson(e)).toList();
      final isLastPage = associates.length < _pageSize;

      if (isLastPage) {
        ratingController.appendLastPage(associates);
      } else {
        ratingController.appendPage(associates, CommonUtility.increment(pageKey));
      }
    } else {
      ratingController.error = response.message;
    }
  }

  @override
  void onClose() {
    ratingController.dispose();

    super.onClose();
  }
}