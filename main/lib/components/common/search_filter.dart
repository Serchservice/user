import 'package:flutter/material.dart';
import 'package:user/library.dart';

class SearchFilter extends StatelessWidget {
  final List<ButtonView> list;
  final Function(ButtonView view) onSelect;
  final int selectedIndex;
  final Widget? more;
  final bool isShortVersion;
  final EdgeInsetsGeometry? buttonPadding;
  final double? buttonTextSize;

  const SearchFilter({
    super.key,
    required this.list,
    required this.onSelect,
    required this.selectedIndex,
    this.more,
    this.isShortVersion = false,
    this.buttonPadding,
    this.buttonTextSize
  });

  @override
  Widget build(BuildContext context) {
    if(more != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFilters(context),
          const SizedBox(width: 10),
          more!
        ],
      );
    } else {
      return _buildFilters(context);
    }
  }

  Widget _buildFilters(BuildContext context) {
    return Wrap(
      runAlignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 5,
      runSpacing: 5,
      children: list.map((view) {
        final bool isSelected = view.index == selectedIndex;
        final Color bgColor = Database.preference.isLightTheme
            ? isSelected
            ? CommonColors.darkTheme2
            : CommonColors.lightTheme2
            : isSelected
            ? CommonColors.lightTheme2
            : CommonColors.darkTheme2;
        final Color txtColor = Database.preference.isLightTheme
            ? isSelected
            ? CommonColors.lightTheme
            : CommonColors.darkTheme
            : isSelected
            ? CommonColors.darkTheme
            : CommonColors.lightTheme;

        if(isShortVersion) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Material(
              color: bgColor,
              child: InkWell(
                onTap: () => onSelect.call(view),
                child: Padding(
                  padding: buttonPadding ?? const EdgeInsets.only(top: 6, bottom: 8, left: 14, right: 14),
                  child: SText(
                    text: view.header,
                    size: Sizing.font(buttonTextSize ?? 11),
                    color: txtColor,
                  ),
                ),
              )
            ),
          );
        }

        return TextButton(
          onPressed: () => onSelect.call(view),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) => bgColor),
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
            padding: WidgetStatePropertyAll(buttonPadding ?? EdgeInsets.symmetric(
              vertical: Sizing.space(4),
              horizontal: Sizing.space(6)
            ))
          ),
          child: SText(
            text: view.header,
            size: Sizing.font(buttonTextSize ?? 11),
            color: txtColor,
          )
        );
      }).toList(),
    );
  }
}