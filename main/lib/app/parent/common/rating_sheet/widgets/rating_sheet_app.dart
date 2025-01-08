import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class RatingSheetApp extends StatelessWidget {
  final RatingSheetController controller;
  final Function(String, double) onSuccess;

  const RatingSheetApp({super.key, required this.controller, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      child: SingleChildScrollView(
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
              text: "This helps us in growing our brand so as to make sure we give out the best user experience you love.",
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
            Obx(() {
              bool hasNotSelectedComments = controller.state.comments.isEmpty;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RatingSheetFilters(
                    list: controller.appComments,
                    selected: controller.state.comments,
                    onSelected: controller.pickAppComment
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
}