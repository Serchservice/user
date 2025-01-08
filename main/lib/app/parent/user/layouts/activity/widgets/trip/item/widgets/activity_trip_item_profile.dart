import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ActivityTripItemProfile extends StatelessWidget {
  final UserResponse user;
  final bool showCall;

  const ActivityTripItemProfile({super.key, required this.user, this.showCall = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Avatar.small(avatar: user.avatar),
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
                      text: user.name,
                      size: Sizing.font(15),
                      weight: FontWeight.bold,
                      flow: TextOverflow.ellipsis,
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                  RatingIcon(rating: user.rating)
                ],
              ),
              SText(
                text: user.role,
                size: Sizing.font(14),
                flow: TextOverflow.ellipsis,
                color: Theme.of(context).primaryColor
              ),
            ]
          ),
        ),
        if(showCall) ...[
          SizedBox(width: 20),
          CircledButton(title: "Call", icon: Icons.call, onClick: () => RouteNavigator.callNumber(user.phone))
        ]
      ],
    );
  }
}