import 'package:user/library.dart';
import 'package:flutter/material.dart';

class MultiFactorCodeUsage extends StatelessWidget {
  const MultiFactorCodeUsage({
    super.key,
    required this.header,
    required this.value
  });

  final String header;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Sizing.space(8),
          vertical: Sizing.space(16)
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            SText(
              text: header,
              color: Theme.of(context).primaryColorLight,
              size: Sizing.font(12),
              weight: FontWeight.bold
            ),
            const SizedBox(height: 5),
            SText(
              text: value,
              color: Theme.of(context).primaryColorLight,
              size: Sizing.font(24),
              weight: FontWeight.bold
            ),
          ],
        )
      ),
    );
  }
}