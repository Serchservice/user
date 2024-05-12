import 'package:flutter/material.dart';
import 'package:user/library.dart';

class RatingReview extends StatelessWidget {
  const RatingReview({
    super.key, required this.review,
  });

  final Rating review;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(Sizing.space(8)),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(Sizing.space(18)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColorDark,
                ),
                child: RatingIcon(
                  rating: review.rating,
                  color: Theme.of(context).scaffoldBackgroundColor
                )
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SText.center(
                      text: review.name,
                      size: Sizing.space(14),
                      color: Theme.of(context).primaryColor,
                    ),
                    SText.center(
                      text: review.category,
                      size: Sizing.space(9),
                      color: Theme.of(context).primaryColor,
                    ),
                    SText(
                      text: review.comment,
                      size: Sizing.space(9),
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                )
              ),
              const SizedBox(width: 10),
              CategoryImage(
                image: review.image,
                width: 100,
                height: 50
              )
            ],
          ),
        ),
        Divider(color: Theme.of(context).primaryColor),
      ],
    );
  }
}