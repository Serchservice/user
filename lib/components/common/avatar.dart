import 'package:flutter/material.dart';
import 'package:user/library.dart';

class Avatar extends StatelessWidget {
  final String avatar;
  final double radius;
  final VoidCallback? onClick;

  const Avatar({
    super.key,
    required this.radius,
    String? avatar,
    this.onClick
  }) : avatar = avatar ?? "";

  const Avatar.large({
    super.key,
    String? avatar,
    this.onClick
  }) : radius = 50,
    avatar = avatar ?? "";

  const Avatar.medium({
    super.key,
    String? avatar,
    this.onClick
  }) : radius = 30,
    avatar = avatar ?? "";

  const Avatar.small({
    super.key,
    String? avatar,
    this.onClick
  }) : radius = 20,
    avatar = avatar ?? "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Theme.of(context).unselectedWidgetColor,
        foregroundImage: AssetUtility.image(
          avatar,
          fallback: Database.preference.isDarkTheme
            ? Media.light
            : Media.dark
        ),
        onForegroundImageError: (exception, stackTrace) => AssetImage(
          Database.preference.isDarkTheme
            ? Media.light
            : Media.dark
        ),
      ),
    );
  }
}