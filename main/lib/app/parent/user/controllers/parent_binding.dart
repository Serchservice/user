import 'package:get/get.dart';
import 'package:user/library.dart';

class ParentBinding extends Bindings {
  @override
  void dependencies() {
    if(!Get.isRegistered<ParentController>()) {
      Get.lazyPut<ParentController>(() => ParentController());
    }

    if(!Get.isRegistered<HomeController>()) {
      Get.put<HomeController>(HomeController());
    }

    if(!Get.isRegistered<EventController>()) {
      Get.put<EventController>(EventController());
    }

    if(!Get.isRegistered<ConnectController>()) {
      Get.put<ConnectController>(ConnectController());
    }

    ChatRoomListController.bind();

    if(!Get.isRegistered<CallChannelListController>()) {
      Get.put<CallChannelListController>(CallChannelListController());
    }

    CallConfiguration.bind();

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

    if(!Get.isRegistered<SpeakWithSerchController>()) {
      Get.put<SpeakWithSerchController>(SpeakWithSerchController());
    }

    if(!Get.isRegistered<CentreController>()) {
      Get.put<CentreController>(CentreController());
    }

    if(!Get.isRegistered<SharedLinksController>()) {
      Get.put<SharedLinksController>(SharedLinksController());
    }
  }
}