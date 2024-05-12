import 'package:flutter/material.dart';
import 'package:user/library.dart';

class CentreNavigator extends StatelessWidget {
  final ButtonView tab;
  final VoidCallback? onTap;
  final bool needNotification;
  final Color? color;
  const CentreNavigator({
    super.key,
    required this.tab,
    this.onTap,
    this.needNotification = false,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(Sizing.space(16)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                tab.icon,
                color: color ?? Theme.of(context).primaryColor,
                size: Sizing.space(24)
              ),
              const SizedBox(width: 10),
              Expanded(child: _body(context)),
              _notification(context)
            ],
          ),
        )
      )
    );
  }

  Widget _body(BuildContext context) {
    if(tab.body.isEmpty) {
      return SText(
        text: tab.header,
        size: Sizing.font(15),
        color: color ?? Theme.of(context).primaryColor
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SText(
            text: tab.header,
            size: Sizing.font(15),
            color: color ?? Theme.of(context).primaryColor
          ),
          SText(
            text: tab.body,
            size: Sizing.font(12),
            color: color ?? Theme.of(context).primaryColorLight
          ),
        ],
      );
    }
  }

  Widget _notification(BuildContext context) {
    if(needNotification) {
      return HeartBeating(
        child: Container(
          padding: EdgeInsets.all(Sizing.space(3)),
          decoration: BoxDecoration(
            color: color ?? Theme.of(context).primaryColor,
            shape: BoxShape.circle
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}