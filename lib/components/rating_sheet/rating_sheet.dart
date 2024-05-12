import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class RatingSheet extends StatelessWidget {
  final Function(String, double) onSuccess;
  final String header;
  final String tag;
  final String event;

  const RatingSheet({
    super.key,
    required this.onSuccess,
    required this.header,
    required this.tag,
    this.event = ""
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RatingSheetController>(
      init: RatingSheetController(
        tag: tag,
        event: event
      ),
      builder: (controller) {
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
                text: header,
                color: Theme.of(context).primaryColor,
                size: Sizing.font(24),
                weight: FontWeight.bold,
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
              Field(
                noEnabledColor: true,
                needLabel: true,
                hintText: "Comment (Optional)",
                keyboard: TextInputType.name,
                controller: controller.controller,
                labelColor: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 15),
              Center(
                child: Obx(() => LoadingButton(
                  text: "Send your rating",
                  borderRadius: 24,
                  width: MediaQuery.of(context).size.width,
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
    );
  }

  static void open({
    required Function(String, double) onSuccess,
    required String header,
    required String tag,
    String event = ""
  }) => Navigate.bottomSheet(
    sheet: RatingSheet(
      onSuccess: onSuccess,
      header: header,
      tag: tag,
      event: event,
    ),
    route: "/rating/product/${tag.toLowerCase()}",
    background: Colors.transparent,
    isScrollable: true
  );
}