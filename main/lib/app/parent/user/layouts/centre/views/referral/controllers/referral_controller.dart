import 'package:user/library.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ReferralController extends GetxController {
  ReferralController();
  final state = ReferralState();

  final ConnectService _connect = Connect();

  final _pageSize = 20;
  final PagingController<int, Referral> referralController = PagingController(firstPageKey: 0);

  @override
  void onInit() {
    referralController.addPageRequestListener((pageKey) {
      _fetchReferrals(pageKey);
    });

    super.onInit();
  }

  void _fetchReferrals(int pageKey) async {
    var response = await _connect.get(endpoint: "/referral?page=$pageKey&size=$_pageSize");

    if(response.isOk) {
      List<dynamic> result = response.data;
      List<Referral> associates = result.map((e) => Referral.fromJson(e)).toList();
      final isLastPage = associates.length < _pageSize;

      if (isLastPage) {
        referralController.appendLastPage(associates);
      } else {
        referralController.appendPage(associates, CommonUtility.increment(pageKey));
      }
    } else {
      referralController.error = response.message;
    }
  }

  @override
  void onClose() {
    referralController.dispose();

    super.onClose();
  }
}