import 'package:user/library.dart';
import 'package:flutter/material.dart';

class SpeakWithSerchStatus extends StatelessWidget {
  final SpeakWithSerch message;

  const SpeakWithSerchStatus({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Sizing.space(4)),
      decoration: BoxDecoration(
        color: message.isClosed ? CommonColors.error : message.isResolved ? CommonColors.success : CommonColors.hint,
        borderRadius: BorderRadius.circular(6)
      ),
      child: SText.center(text: message.status, color: CommonColors.lightTheme, size: Sizing.font(12)),
    );
  }
}