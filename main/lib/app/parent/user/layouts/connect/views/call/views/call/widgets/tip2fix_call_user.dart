import 'package:flutter/material.dart';
import 'package:user/library.dart';

class Tip2FixCallUser extends StatelessWidget {
  final String avatar;
  final String image;
  final double? radius;

  const Tip2FixCallUser({super.key, required this.avatar, required this.image, this.radius});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: Center(
        child: Stack(
          children: [
            Avatar(radius: radius ?? 70, avatar: avatar),
            Positioned(right: 5, bottom: 0, child: Avatar(radius: 13, avatar: image)),
          ],
        ),
      ),
    );
  }
}