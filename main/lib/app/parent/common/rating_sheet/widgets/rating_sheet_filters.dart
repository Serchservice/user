import 'package:flutter/material.dart';
import 'package:user/library.dart';

class RatingSheetFilters extends StatelessWidget {
  final List<String> list;
  final List<String> selected;
  final Function(String) onSelected;

  const RatingSheetFilters({super.key, required this.list, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runAlignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 5,
      runSpacing: 5,
      children: list.map((view) {
        final bool isSelected = selected.contains(view);
        return TextButton(
          onPressed: () => onSelected.call(view),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              return Database.preference.isLightTheme
                  ? isSelected
                  ? CommonColors.darkTheme
                  : CommonColors.lightTheme
                  : isSelected
                  ? CommonColors.lightTheme
                  : CommonColors.darkTheme;
            }),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              return Database.preference.isLightTheme
                  ? isSelected
                  ? CommonColors.shimmerBase.withValues(alpha: .48)
                  : CommonColors.hinted
                  : isSelected
                  ? CommonColors.hinted
                  : CommonColors.shimmerBase.withValues(alpha: .48);
            }),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
              vertical: Sizing.space(4),
              horizontal: Sizing.space(6)
            ))
          ),
          child: SText(
            text: view,
            size: Sizing.font(11),
            color: Database.preference.isLightTheme
              ? isSelected
              ? CommonColors.lightTheme
              : CommonColors.darkTheme
              : isSelected
              ? CommonColors.darkTheme
              : CommonColors.lightTheme,
          )
        );
      }).toList(),
    );
  }
}
