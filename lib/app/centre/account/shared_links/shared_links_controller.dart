import 'package:get/get.dart';
import 'package:user/library.dart';

class SharedLinksController extends GetxController {
  SharedLinksController();
  final state = SharedLinksState();

  final HomeController home = HomeController.data;

  void stopShowingSharedLinks() {
    Database.saveNotifier(Database.notifier.copyWith(showSharedLinks: false));
    state.showSharedLinks.value = false;
  }
}