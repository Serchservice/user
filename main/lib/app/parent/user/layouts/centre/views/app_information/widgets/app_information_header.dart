import 'package:user/library.dart';
import 'package:flutter/material.dart';

class AppInformationHeader extends StatelessWidget {
  final double rating;
  final bool isLoading;

  const AppInformationHeader({
    super.key,
    required this.rating,
    required this.isLoading
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GoBack(
                size: Sizing.space(26),
                icon: Icons.close_rounded,
                color: Theme.of(context).primaryColorLight
              ),
            ],
          ),
          Image.asset(
            Media.logo,
            height: 100,
            color: Theme.of(context).primaryColor
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                Media.tagline,
                width: 100,
                color: Theme.of(context).primaryColor
              ),
              if(isLoading) ...[
                LoadingShimmer(
                  content: Container(
                    height: 20,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: CommonColors.shimmerHigh
                    ),
                  )
                )
              ],
              if(!isLoading) ...[
                RatingIcon(rating: rating)
              ]
            ],
          )
        ],
      )
    );
  }
}