import 'package:flutter/material.dart';
import 'package:user/library.dart';

class DashboardCategorySelector extends StatelessWidget {
  final SerchCategory category;
  final Function(SerchCategory) onCategoryPick;
  final bool selected;

  const DashboardCategorySelector({
    super.key,
    required this.category,
    required this.onCategoryPick,
    this.selected = false
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: selected
          ? Theme.of(context).primaryColor
          : Theme.of(context).appBarTheme.backgroundColor,
        child: InkWell(
          onTap: () => onCategoryPick.call(category),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Expanded(
                  child: CategoryImage(
                    image: category.image,
                    height: 50,
                    width: 80
                  )
                ),
                const SizedBox(height: 4),
                SText.center(
                  text: category.type,
                  size: 9,
                  color: selected
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Theme.of(context).primaryColor
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}