import 'package:flutter/material.dart';
import 'package:user/library.dart';

class InAppNotificationContent extends StatelessWidget {
  final bool needLogo;
  final String message;
  final Color? background;
  final Color? color;
  const InAppNotificationContent({
    super.key,
    this.needLogo = false,
    required this.message,
    this.background,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: Sizing.space(6),
            horizontal: Sizing.space(12)
          ),
          decoration: BoxDecoration(
            color: background ?? Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(needLogo ? 16 : 10)
          ),
          child: _buildContent(context),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if(needLogo) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            Media.logo,
            width: 60,
            height: 40,
            color: color ?? Theme.of(context).scaffoldBackgroundColor
          ),
          _buildText(context)
        ],
      );
    } else {
      return _buildText(context);
    }
  }

  Widget _buildText(BuildContext context) {
    return SText(
      text: message,
      size: Sizing.font(12),
      color: color ?? Theme.of(context).scaffoldBackgroundColor
    );
  }
}