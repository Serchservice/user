import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class SharedLinksState {
  /// Show link notification
  RxBool showSharedLinks = RxBool(Database.notifier.showSharedLinks);
}