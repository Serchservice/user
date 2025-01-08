import 'package:flutter/material.dart';
import 'package:user/library.dart';

class PreferenceSelectorItem extends StatelessWidget {
  final bool isSelected;
  final Widget child;
  final VoidCallback? onTap;

  const PreferenceSelectorItem({super.key, required this.isSelected, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          side: isSelected
            ? BorderSide(color: Theme.of(context).primaryColor, width: 3)
            : BorderSide.none,
          borderRadius: BorderRadius.circular(24),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: EdgeInsets.all(Sizing.space(16)), child: child),
        ),
      ),
    );
  }
}