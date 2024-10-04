import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class BadRating extends StatelessWidget {
  const BadRating({super.key, required this.controller});

  final RatingController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(controller.state.isFetching.value) {
        return LoadingShimmer(
          content: Expanded(
            child: ListView.builder(
              itemCount: 10,
              padding: EdgeInsets.all(Sizing.space(10)),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.sizeOf(context).width,
                  margin: EdgeInsets.only(bottom: Sizing.space(10)),
                  height: 90,
                  decoration: BoxDecoration(
                    color: CommonColors.shimmerHigh,
                    borderRadius: BorderRadius.circular(6)
                  ),
                );
              }
            ),
          )
        );
      } else if(!controller.state.isFetching.value && controller.state.badList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Opacity(
                opacity: 0.2,
                child: Image.asset(
                  Media.review,
                  width: 250
                ),
              ),
              SText(
                text: "You have no bad reviews yet.",
                color: Theme.of(context).primaryColorDark,
                size: Sizing.font(20)
              ),
            ],
          )
        );
      } else {
        return ListView.builder(
          itemCount: controller.state.badList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return RatingReview(review: controller.state.badList[index]);
          }
        );
      }
    });
  }
}