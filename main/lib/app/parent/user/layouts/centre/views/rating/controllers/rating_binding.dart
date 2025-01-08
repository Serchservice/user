import 'package:user/library.dart';
import 'package:get/get.dart';

class RatingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RatingController>(() => RatingController());

    Get.put<RatingBadTabController>(RatingBadTabController());
    Get.put<RatingGoodTabController>(RatingGoodTabController());
    Get.put<RatingSummaryTabController>(RatingSummaryTabController());
  }
}