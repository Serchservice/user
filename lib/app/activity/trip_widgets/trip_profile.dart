import 'package:flutter/material.dart';
import 'package:user/components/others/quick_user_view.dart';
import 'package:user/library.dart';

class TripProfile extends StatelessWidget {
  final UserResponse user;
  final bool needPhone;
  const TripProfile({super.key, required this.user, this.needPhone = true});

  @override
  Widget build(BuildContext context) {
    if(user.phone.isNotEmpty && needPhone) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Avatar.medium(avatar: user.avatar),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SText(
                          text: user.name,
                          size: Sizing.font(15),
                          weight: FontWeight.bold,
                          flow: TextOverflow.ellipsis,
                          color: Theme.of(context).primaryColor
                      ),
                      RatingIcon(rating: user.rating),
                      SText(
                          text: user.role,
                          size: Sizing.font(12),
                          flow: TextOverflow.ellipsis,
                          color: Theme.of(context).primaryColor
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                CircledButton(
                    title: "Call",
                    icon: Icons.call,
                    onClick: () => RouteNavigator.callNumber(user.phone)
                )
              ]
            ),
          ),
        ],
      );
    } else {
      return QuickUserView(user: user);
    }
  }
}