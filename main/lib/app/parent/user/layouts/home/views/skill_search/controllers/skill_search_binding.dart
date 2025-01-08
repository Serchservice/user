import 'package:get/get.dart';
import 'package:user/library.dart';

class SkillSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SkillSearchController>(() => SkillSearchController());
  }
}