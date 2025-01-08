import 'package:flutter/material.dart';
import 'package:user/library.dart';

class GuestCentreSwitcher extends StatelessWidget {
  final VoidCallback onTap;
  const GuestCentreSwitcher({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Material(
          color: CommonUtility.lightenColor(CommonColors.allday, 45),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  SText(
                    text: "Your account seems not be registered as a guest. If you ever feel like becoming a user, "
                      "you can do so without creating a new account so that you can link your guest account/s to your user "
                      "account.",
                    size: Sizing.font(14),
                    color: CommonColors.lightTheme
                  ),
                  SText(
                    text: "Tap here to become a user",
                    size: Sizing.font(14),
                    color: CommonColors.lightTheme
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
