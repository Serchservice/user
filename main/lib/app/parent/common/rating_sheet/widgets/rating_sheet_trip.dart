import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class RatingSheetTrip extends StatelessWidget {
  final RatingSheetController controller;
  final Function(String, double) onSuccess;
  final TripResponse trip;

  const RatingSheetTrip({super.key, required this.controller, required this.trip, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      borderRadius: BorderRadius.zero,
      safeArea: true,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GoBack(icon: Icons.arrow_back, color: Theme.of(context).primaryColor),
            const SizedBox(height: 20),
            SText(
              text: "Tell us how you feel about this trip",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(20),
              weight: FontWeight.bold,
            ),
            const SizedBox(height: 5),
            SText(
              text: trip.address,
              size: Sizing.font(14),
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor
            ),
            const SizedBox(height: 30),
            if(trip.provider != null) ...[
              Center(
                child: Column(
                  children: [
                    Avatar.medium(avatar: trip.provider!.avatar),
                    const SizedBox(height: 10),
                    SText(
                      text: trip.provider!.name,
                      color: Theme.of(context).primaryColor,
                      size: Sizing.font(16),
                      weight: FontWeight.bold,
                    ),
                  ]
                )
              ),
              const SizedBox(height: 15),
            ],
            Center(
              child: RatingBar.builder(
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: Sizing.space(4)),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Theme.of(context).primaryColorLight,
                ),
                onRatingUpdate: (rating) {
                  controller.state.rating.value = rating;
                },
              ),
            ),
            const SizedBox(height: 15),
            Obx(() {
              bool hasNotSelectedComments = controller.state.comments.isEmpty;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RatingSheetFilters(
                    list: controller.tripComments,
                    selected: controller.state.comments,
                    onSelected: controller.pickTripComment
                  ),
                  SizedBox(height: 15),
                  if(hasNotSelectedComments) ...[
                    Field(
                      noEnabledColor: true,
                      needLabel: true,
                      hintText: "Comment (Optional)",
                      keyboard: TextInputType.name,
                      controller: controller.controller,
                      labelColor: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 15),
                  ]
                ],
              );
            }),
            if(trip.shared != null && trip.shared!.profile != null && !trip.shared!.isOffline) ...[
              Obx(() => _buildShareRating(context, controller.shareRating, controller.state.shouldApplyToBoth.value)),
              const SizedBox(height: 15),
              Center(
                child: Column(
                  children: [
                    Avatar.medium(avatar: trip.shared!.profile!.avatar),
                    const SizedBox(height: 10),
                    SText(
                      text: trip.shared!.profile!.name,
                      color: Theme.of(context).primaryColor,
                      size: Sizing.font(24),
                      weight: FontWeight.bold,
                    ),
                  ]
                )
              ),
              const SizedBox(height: 15),
              _buildRateProvider(context, controller),
              const SizedBox(height: 15),
            ],
            Center(
              child: Obx(() => LoadingButton(
                text: "Done",
                borderRadius: 24,
                width: MediaQuery.sizeOf(context).width,
                textSize: Sizing.font(14),
                buttonColor: Theme.of(context).primaryColorDark,
                textColor: Theme.of(context).scaffoldBackgroundColor,
                onClick: () => controller.rate(
                  context: context,
                  onSuccess: (comment, rating) => onSuccess.call(comment, rating)
                ),
                loading: controller.state.isRating.value
              )),
            )
          ],
        ),
      )
    );
  }

  Widget _buildRateProvider(BuildContext context, RatingSheetController controller) {
    return Obx(() {
      if(controller.state.shouldApplyToBoth.value) {
        return Container();
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: RatingBar.builder(
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: Sizing.space(4)),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Theme.of(context).primaryColorLight,
                ),
                onRatingUpdate: (rating) {
                  controller.state.rating.value = rating;
                },
              ),
            ),
            const SizedBox(height: 15),
            RatingSheetFilters(
              list: controller.tripComments,
              selected: controller.state.comments,
              onSelected: controller.pickTripComment
            ),
            const SizedBox(height: 15),
            if(controller.state.comments.isEmpty) ...[
              Field(
                noEnabledColor: true,
                needLabel: true,
                hintText: "Comment (Optional)",
                keyboard: TextInputType.name,
                controller: controller.controller,
                labelColor: Theme.of(context).primaryColor,
              ),
            ],
          ],
        );
      }
    });
  }

  Widget _buildShareRating(BuildContext context, Function(bool) onChanged, bool initial) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SText(
                text: "Share rating",
                size: Sizing.font(15),
                color: Theme.of(context).primaryColor
              ),
              SText(
                text: "Apply the same rating and comment to both entities involved in this trip",
                size: Sizing.font(12),
                color: Theme.of(context).primaryColorLight
              ),
            ],
          )
        ),
        const SizedBox(width: 30),
        Switcher(onChanged: onChanged, value: initial)
      ],
    );
  }
}