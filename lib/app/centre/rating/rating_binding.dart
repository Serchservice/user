import 'package:get/get.dart';
import 'package:user/library.dart';

class RatingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RatingController>(() => RatingController());
  }
}