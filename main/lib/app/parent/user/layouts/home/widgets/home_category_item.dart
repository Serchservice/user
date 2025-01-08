import 'package:flutter/material.dart';
import 'package:user/library.dart';

class HomeCategoryItem extends StatelessWidget {
  final SerchCategory category;
  final Function(SerchCategory)? onPicked;
  final bool selected;
  final bool smallVersion;
  final bool shouldExpand;

  const HomeCategoryItem({
    super.key,
    required this.category,
    this.onPicked,
    this.smallVersion = false,
    this.selected = false,
    this.shouldExpand = true
  });

  @override
  Widget build(BuildContext context) {
    if(smallVersion) {
      return Row(children: [_build(context)]);
    } else {
      return _build(context);
    }
  }

  Widget _build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: selected ? Theme.of(context).primaryColor : Theme.of(context).appBarTheme.backgroundColor,
        child: InkWell(
          onTap: () => onPicked?.call(category),
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    Color color = selected ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).primaryColor;

    if(smallVersion) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          spacing: 4,
          children: [
            CategoryImage(image: category.image, height: 30, width: 40),
            const SizedBox(height: 4),
            SText.center(text: category.type, size: 12, color: color)
          ],
        )
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          spacing: 4,
          children: [
            shouldExpand
                ? Expanded(child: CategoryImage(image: category.image, height: 80, width: 80))
                : CategoryImage(image: category.image, height: 80, width: 80),
            SText.center(text: category.type, size: 9, color: color)
          ],
        )
      );
    }
  }
}