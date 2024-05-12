import 'package:get/get.dart';

class RatingSheetState {
  /// Rating value
  RxDouble rating = RxDouble(0.0);

  /// Is rating
  RxBool isRating = RxBool(false);

  /// Rating Tags = [APP (In app rating), CALL (Must come with call id), TRIP ]
  RxString tag = RxString("APP");

  /// Event Id (If not app)
  RxString event = RxString("APP");
}