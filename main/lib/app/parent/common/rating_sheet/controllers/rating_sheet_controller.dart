import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class RatingSheetController extends GetxController {
  final TripResponse? trip;
  final ActiveCallResponse? call;

  RatingSheetController({this.trip, this.call});

  final state = RatingSheetState();
  final TextEditingController controller = TextEditingController();
  final TextEditingController invitedController = TextEditingController();
  final ConnectService _connect = Connect(useToken: Database.isUserActive);

  @override
  void onClose() {
    controller.dispose();
    invitedController.dispose();

    super.dispose();
  }

  List<String> appComments = [
    "Awesome with good user experience",
    "Easy to navigate and use",
    "Fast and reliable",
    "Needs improvement in certain areas",
    "Occasionally crashes",
    "Great design but could be more intuitive",
    "Useful features, but some bugs need fixing",
    "Highly recommend it to others",
    "Could use more customization options",
    "Great app, but some features are hard to find"
  ];

  List<String> tripComments = [
    "Punctual",
    "Skilled in the service",
    "Friendly and helpful",
    "Very professional",
    "Quick response time",
    "Good communication skills",
    "Service was above expectations",
    "Clean and well-maintained tools",
    "Went the extra mile to assist",
    "Great value for money",
    "Could improve punctuality",
    "Lacked professionalism",
    "Not as friendly as expected",
    "Service was delayed",
    "Average service"
  ];

  List<String> tripInvitedComments = [
    "Easy to coordinate with",
    "Flexible with scheduling",
    "Very accommodating",
    "Prompt responses",
    "Polite and courteous",
    "Showed up on time",
    "Reliable and trustworthy",
    "Provided all necessary information",
    "Could improve communication",
    "Rescheduled multiple times",
    "Wasn't very clear with instructions",
    "Great attitude throughout",
    "Seemed unprepared for the trip",
    "Arrived late but was apologetic",
    "Canceled at the last minute"
  ];

  void pickAppComment(String comment) {
    if (state.comments.contains(comment)) {
      state.comments.remove(comment);
    } else {
      state.comments.add(comment);
    }

    state.comments.refresh();
  }

  void pickTripComment(String comment) {
    if (state.comments.contains(comment)) {
      state.comments.remove(comment);
    } else {
      state.comments.add(comment);
    }

    state.comments.refresh();
  }

  void pickTripInvitedComment(String comment) {
    if (state.invitedComments.contains(comment)) {
      state.invitedComments.remove(comment);
    } else {
      state.invitedComments.add(comment);
    }

    state.invitedComments.refresh();
  }

  void shareRating(bool value) {
    state.shouldApplyToBoth.value = value;
  }

  void rate({required BuildContext context, required Function(String, double) onSuccess}) {
    CommonUtility.unfocus(context);

    if(trip == null && call == null) {
      rateApp(onSuccess: (comment, rating) => onSuccess.call(comment, rating));
    } else if(trip != null) {
      rateTrip(onSuccess: () => onSuccess.call("", 0.0));
    }
  }

  void rateApp({required Function(String, double) onSuccess}) async {
    state.isRating.value = true;

    String comment = state.comments.isNotEmpty ? state.comments.join(", ") : controller.text.trim();
    var response = await _connect.post(
      endpoint: "/rating/rate/app",
      body: {
        "rating": state.rating.value,
        "account": Database.isUserActive ? "" : Database.guest.id,
        "comment": comment
      }
    );
    state.isRating.value = false;
    if(response.isOk) {
      AppRating rating = AppRating.fromJson(response.data);
      Database.saveAppRating(rating);
      onSuccess.call(controller.text.trim(), state.rating.value);
    }
  }

  void rateTrip({required VoidCallback onSuccess}) async {
    state.isRating.value = true;
    String comment = state.comments.isNotEmpty ? state.comments.join(", ") : controller.text.trim();

    Map<String, dynamic> data = {
      "id": trip!.id,
      "guest": Database.isUserActive ? "" : Database.guest.id,
      "rating": state.rating.value,
      "comment": comment,
    };

    if(state.shouldApplyToBoth.value) {
      data.putIfAbsent("is_both", () => true);

      var response = await _connect.post(endpoint: "/rating/rate", body: data);
      state.isRating.value = false;
      if(response.isOk) {
        onSuccess.call();
      }
    } else {
      if(trip!.shared != null && !trip!.shared!.isOffline) {
        String invitedComment = state.invitedComments.isNotEmpty ? state.invitedComments.join(", ") : controller.text.trim();
        Map<String, dynamic> invited = {
          "id": trip!.id,
          "guest": Database.isUserActive ? "" : Database.guest.id,
          "invited": state.invited.value,
          "comment": invitedComment,
        };

        var response = [
          await _connect.post(endpoint: "/rating/rate", body: data),
          await _connect.post(endpoint: "/rating/rate", body: invited)
        ];
        state.isRating.value = false;
        if(response.any((r) => !r.isSuccessful)) {
          return;
        } else {
          onSuccess.call();
        }
      } else {
        var response = await _connect.post(endpoint: "/rating/rate", body: data);
        state.isRating.value = false;
        if(response.isOk) {
          onSuccess.call();
        }
      }
    }
  }
}