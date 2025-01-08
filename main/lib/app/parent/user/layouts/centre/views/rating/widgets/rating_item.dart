import 'package:user/library.dart';
import 'package:flutter/material.dart';

class RatingItem extends StatelessWidget {
  final Rating review;
  const RatingItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Sizing.space(8)),
      child: Row(
        children: [
          CategoryImage(image: review.image, width: 40, height: 40),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SText(
                        text: review.category,
                        size: Sizing.space(9),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    RatingIcon(
                        rating: review.rating,
                        iconSize: Sizing.font(12),
                        textSize: Sizing.font(10),
                        color: Theme.of(context).primaryColor
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if(review.comment.isNotEmpty) ...[
                  SText(
                    text: review.comment,
                    size: Sizing.space(9),
                    color: Theme.of(context).primaryColor,
                  ),
                ] else ...[
                  SText(
                    text: "No comment...",
                    size: Sizing.space(9),
                    color: Theme.of(context).primaryColor,
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}