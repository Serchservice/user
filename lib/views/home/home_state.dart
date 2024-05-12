import 'package:get/get.dart';
import 'package:user/library.dart';

class HomeState {
  /// Current Index of the navigator
  RxInt routeIndex = 0.obs;

  /// Timeout count
  RxInt timeout = 59.obs;

  /// Current theme mode
  Rx<ThemeType> theme = Database.preference.theme.obs;

  /// First name
  RxString firstName = RxString(Database.auth.firstName);

  /// Full name
  RxString name = RxString(Database.auth.name);

  /// Rating
  RxDouble rating = RxDouble(Database.auth.rating);

  /// Category image
  RxString image = RxString(Database.auth.image);

  /// Avatar
  RxString avatar = RxString(Database.auth.avatar);

  /// Has Unread message from Speak with Serch
  RxBool hasSerchMessage = RxBool(true);

  /// List of SpeakWithSerch Messages
  RxList<SpeakWithSerch> speakWithSerch = <SpeakWithSerch>[].obs;
}