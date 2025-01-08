import 'package:user/library.dart';
import 'package:flutter/material.dart';

class ReferralItem extends StatelessWidget {
  final Referral referral;

  const ReferralItem({super.key, required this.referral});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Sizing.space(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar.small(avatar: referral.avatar),
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
                        text: referral.name,
                        size: Sizing.space(14),
                        color: Theme.of(context).primaryColor,
                        flow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SText.right(
                      text: referral.role,
                      size: Sizing.space(12),
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
                SText(
                  text: referral.info,
                  size: Sizing.space(9),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}
