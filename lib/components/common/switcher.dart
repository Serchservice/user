import 'package:flutter/material.dart';
import 'package:user/library.dart';

class Switcher extends StatelessWidget {
  const Switcher({
    super.key,
    required this.onChanged,
    required this.value,
  });

  final Function(bool val) onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      trackOutlineColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (value) {
          return CommonColors.green;
        } else {
          return Colors.green.withOpacity(.48);
        }
      }),
      // trackOutlineWidth: MaterialStateProperty.resolveWith<double?>((Set<MaterialState> states) {
      //   if (value) {
      //     return 22.0;
      //   } else {
      //     return 15.0; // Use the default width.
      //   }
      // }),
      trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if(Database.preference.isDarkTheme) {
          return CommonColors.lightTheme2;
        } else {
          return CommonColors.darkTheme2;
        }
      }),
      thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (value) {
          return CommonColors.success;
        } else {
          return Theme.of(context).primaryColor;
        }
      }),
      thumbIcon: MaterialStateProperty.resolveWith<Icon?>((Set<MaterialState> states) {
        if (value) {
          return Icon(Icons.check, size: Sizing.space(15));
        } else {
          return const Icon(Icons.check);
        }
      }),
    );
  }
}