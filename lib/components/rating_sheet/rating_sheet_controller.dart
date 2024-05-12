import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class RatingSheetController extends GetxController {
  final String tag;
  final String event;
  RatingSheetController({
    required this.tag,
    required this.event
  });

  final state = RatingSheetState();
  final TextEditingController controller = TextEditingController();
  final Connect _connect = Connect();

  void rate({required BuildContext context, required Function(String, double) onSuccess}) {
    CommonUtility.unfocus(context);

    if(tag.toUpperCase() == "APP") {
      rateApp(onSuccess: (comment, rating) => onSuccess.call(comment, rating));
    }
  }

  void rateApp({required Function(String, double) onSuccess}) async {
    state.isRating.value = true;
    try {
      var res = await _connect.post(
        endpoint: "/rating/rate/app",
        body: {
          "rating": state.rating.value,
          "account": "",
          "comment": controller.text.trim()
        }
      );
      ApiResponse response = ApiResponse.fromJson(res.data);
      state.isRating.value = false;
      if(response.isOk) {
        AppRating rating = AppRating.fromJson(response.data);
        Database.saveAppRating(rating);
        onSuccess.call(controller.text.trim(), state.rating.value);
      }
    } on Exception catch (_) {
      state.isRating.value = false;
    }
  }
}