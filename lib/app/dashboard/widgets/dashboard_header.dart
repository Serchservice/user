import 'package:flutter/material.dart';
import 'package:user/library.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.name,
    required this.image,
    required this.onSerch,
    required this.onAccounts
  });

  final String name;
  final String image;
  final VoidCallback onSerch;
  final VoidCallback onAccounts;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.only(
        bottom: Sizing.space(16),
        left: Sizing.space(16),
        right: Sizing.space(16)
      ),
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onSerch,
                child: Image.asset(
                  Media.logo,
                  width: 80,
                  color: Theme.of(context).primaryColor
                ),
              ),
              IconButton(
                onPressed: onAccounts,
                tooltip: "View accounts",
                icon: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle_rounded,
                      color: Theme.of(context).primaryColor
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Theme.of(context).primaryColor
                    ),
                  ],
                ),
              )
            ],
          ),
          SText(
            text: CommonUtility.greeting(name),
            size: Sizing.font(20),
            weight: FontWeight.w700,
            color: Theme.of(context).primaryColor
          ),
          SText(
            text: CommonUtility.statements(),
            size: Sizing.font(14),
            color: Theme.of(context).primaryColor
          ),
        ],
      ),
    );
  }
}