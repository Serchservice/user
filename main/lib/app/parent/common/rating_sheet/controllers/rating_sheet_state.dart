import 'package:get/get.dart';

class RatingSheetState {
  /// Rating value
  RxDouble rating = RxDouble(0.0);

  /// Rating value for provider
  RxDouble invited = RxDouble(0.0);

  /// Apply to both
  RxBool shouldApplyToBoth = RxBool(false);

  /// Comments
  RxList<String> comments = RxList();

  /// Invited comments
  RxList<String> invitedComments = RxList();

  /// Is rating
  RxBool isRating = RxBool(false);
}