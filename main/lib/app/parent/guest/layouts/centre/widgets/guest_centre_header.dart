import 'package:flutter/cupertino.dart';
import 'package:user/library.dart';
import 'package:flutter/material.dart';

class GuestCentreHeader extends StatelessWidget {
  final String name;
  final bool confirmed;
  final String avatar;

  const GuestCentreHeader({
    super.key,
    required this.name,
    required this.confirmed,
    required this.avatar
  });

  @override
  Widget build(BuildContext context) {
    Color color = confirmed ? CommonColors.green : Theme.of(context).primaryColor;

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
                      child: Row(
                        spacing: 5,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            confirmed
                              ? CupertinoIcons.checkmark_alt_circle_fill
                              : CupertinoIcons.circle_grid_hex_fill,
                            color: color,
                            size: 18,
                          ),
                          SText(
                            text: confirmed ? "Email Confirmed" : "Email not confirmed",
                            color: color,
                            size: Sizing.font(14),
                            weight: FontWeight.bold
                          ),
                        ],
                      )
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