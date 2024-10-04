import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class RatingSheet extends StatelessWidget {
  final Function(String, double) onSuccess;
  final TripResponse? trip;
  final ActiveCallResponse? call;

  const RatingSheet({super.key, required this.onSuccess, this.call, this.trip});

  static void open({required Function(String, double) onSuccess, TripResponse? trip, ActiveCallResponse? call}) {
    Navigate.bottomSheet(
      sheet: RatingSheet(onSuccess: onSuccess, trip: trip, call: call),
      route: trip != null ? "/rating/product/trip?id=${trip.id}" : call != null ? "/rating/product/${call.channel}"
        : "/rating/product/app",
      background: Colors.transparent,
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RatingSheetController>(
      init: RatingSheetController(trip: trip, call: call),
      builder: (controller) {
        if(trip == null && call == null) {
          return _buildAppRating(context, controller);
        } else if(trip != null) {
          return _buildTripRating(context, controller);
        } else if(call != null) {
          return _buildCallRating(context, controller);
        } else {
          return Container();
        }
      }
    );
  }

  Widget _buildAppRating(BuildContext context, RatingSheetController controller) {
    return CurvedBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(Sizing.space(2)),
              width: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(16)
              ),
            ),
          ),
          const SizedBox(height: 20),
          SText(
            text: "We would love to know how you feel about us",
            color: Theme.of(context).primaryColor,
            size: Sizing.font(20),
            weight: FontWeight.bold,
          ),
          SText(
            text: "This helps us in growing our brand so as to make sure we give out the best user experience"
            " you love.",
            color: Theme.of(context).primaryColor,
            size: Sizing.font(14),
          ),
          const SizedBox(height: 15),
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
          Obx(() => _buildFilters(
            context,
            controller.appComments,
            controller.state.comments,
            controller.pickAppComment
          )),
          const SizedBox(height: 15),
          Obx(() {
            if(controller.state.comments.isEmpty) {
              return Field(
                noEnabledColor: true,
                needLabel: true,
                hintText: "Comment (Optional)",
                keyboard: TextInputType.name,
                controller: controller.controller,
                labelColor: Theme.of(context).primaryColor,
              );
            } else {
              return Container();
            }
          }),
          const SizedBox(height: 15),
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
      )
    );
  }

  Widget _buildTripRating(BuildContext context, RatingSheetController controller) {
    return CurvedBottomSheet(
      borderRadius: BorderRadius.zero,
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
            text: trip!.address,
            size: Sizing.font(14),
            weight: FontWeight.bold,
            color: Theme.of(context).primaryColor
          ),
          const SizedBox(height: 30),
          if(trip!.provider != null) ...[
            Center(
              child: Column(
                children: [
                  Avatar.medium(avatar: trip!.provider!.avatar),
                  const SizedBox(height: 10),
                  SText(
                    text: trip!.provider!.name,
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
          Obx(() => _buildFilters(
            context,
            controller.tripComments,
            controller.state.comments,
            controller.pickTripComment
          )),
          const SizedBox(height: 15),
          Obx(() {
            if(controller.state.comments.isEmpty) {
              return Field(
                noEnabledColor: true,
                needLabel: true,
                hintText: "Comment (Optional)",
                keyboard: TextInputType.name,
                controller: controller.controller,
                labelColor: Theme.of(context).primaryColor,
              );
            } else {
              return Container();
            }
          }),
          const SizedBox(height: 15),
          if(trip!.shared != null && trip!.shared!.profile != null && !trip!.shared!.isOffline) ...[
            Obx(() => _buildShareRating(
              context,
              controller.shareRating,
              controller.state.shouldApplyToBoth.value
            )),
            const SizedBox(height: 15),
            Center(
              child: Column(
                children: [
                  Avatar.medium(avatar: trip!.shared!.profile!.avatar),
                  const SizedBox(height: 10),
                  SText(
                    text: trip!.shared!.profile!.name,
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
            _buildFilters(
                context,
                controller.tripComments,
                controller.state.comments,
                controller.pickTripComment
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

  Widget _buildCallRating(BuildContext context, RatingSheetController controller) {
    return Container();
  }

  Widget _buildFilters(BuildContext context, List<String> list, List<String> selected, Function(String) onSelected) {
    return Wrap(
      runAlignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 5,
      runSpacing: 5,
      children: list.map((view) {
        final bool isSelected = selected.contains(view);
        return TextButton(
          onPressed: () => onSelected.call(view),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              return Database.preference.isLightTheme
                ? isSelected
                ? CommonColors.darkTheme
                : CommonColors.lightTheme
                : isSelected
                ? CommonColors.lightTheme
                : CommonColors.darkTheme;
            }),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              return Database.preference.isLightTheme
                ? isSelected
                ? CommonColors.shimmerBase.withOpacity(.48)
                : CommonColors.hinted
                : isSelected
                ? CommonColors.hinted
                : CommonColors.shimmerBase.withOpacity(.48);
            }),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
              vertical: Sizing.space(4),
              horizontal: Sizing.space(6)
            ))
          ),
          child: SText(
            text: view,
            size: Sizing.font(11),
            color: Database.preference.isLightTheme
              ? isSelected
              ? CommonColors.lightTheme
              : CommonColors.darkTheme
              : isSelected
              ? CommonColors.darkTheme
              : CommonColors.lightTheme,
          )
        );
      }).toList(),
    );
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