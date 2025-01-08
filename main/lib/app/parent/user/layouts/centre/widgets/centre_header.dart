import 'package:user/library.dart';
import 'package:flutter/material.dart';

class CentreHeader extends StatelessWidget {
  final String name;
  final double rating;
  final String avatar;

  const CentreHeader({
    super.key,
    required this.name,
    required this.rating,
    required this.avatar
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
      padding: EdgeInsets.all(Sizing.space(24)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SText(
                  text: name,
                  color: Theme.of(context).primaryColor,
                  size: Sizing.font(30),
                  weight: FontWeight.bold
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: Sizing.space(3),
                        horizontal: Sizing.space(4)
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: RatingIcon(rating: rating)
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(width: 10),
          Avatar.large(avatar: avatar)
        ],
      ),
    );
  }
}