import 'package:flutter/cupertino.dart';
import 'package:user/library.dart';

class VoiceCallUser extends StatelessWidget {
  final String avatar;
  final String image;
  final double? radius;

  const VoiceCallUser({super.key, required this.avatar, required this.image, this.radius});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Avatar(radius: radius ?? 70, avatar: avatar),
          Positioned(right: 5, bottom: 0, child: Avatar(radius: 13, avatar: image)),
        ],
      ),
    );
  }
}