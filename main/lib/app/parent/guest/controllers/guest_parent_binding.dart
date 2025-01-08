import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestParentBinding extends Bindings {
  @override
  void dependencies() {
    if(!Get.isRegistered<GuestParentController>()) {
      Get.lazyPut<GuestParentController>(() => GuestParentController());
    }

    if(!Get.isRegistered<GuestHomeController>()) {
      Get.put<GuestHomeController>(GuestHomeController());
    }

    if(!Get.isRegistered<EventController>()) {
      Get.put<EventController>(EventController());
    }

    if(!Get.isRegistered<ActivityController>()) {
      Get.put<ActivityController>(ActivityController());
    }

    if(!Get.isRegistered<ActivityActiveController>()) {
      Get.put<ActivityActiveController>(ActivityActiveController());
    }

    if(!Get.isRegistered<ActivityHistoryController>()) {
      Get.put<ActivityHistoryController>(ActivityHistoryController());
    }

    if(!Get.isRegistered<ActivityRequestedController>()) {
      Get.put<ActivityRequestedController>(ActivityRequestedController());
    }

    if(!Get.isRegistered<GuestCentreController>()) {
      Get.put<GuestCentreController>(GuestCentreController());
    }
  }
}