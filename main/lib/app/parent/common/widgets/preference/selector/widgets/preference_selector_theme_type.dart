import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class PreferenceSelectorThemeType extends StatelessWidget {
  final PreferenceSelectorController controller;

  const PreferenceSelectorThemeType({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisExtent: 250
      ),
      itemCount: ThemeType.values.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final theme = ThemeType.values[index];

        return Obx(() {
          ThemeType selected = controller.state.theme.value;

          return PreferenceSelectorItem(
            isSelected: selected == theme,
            onTap: () => controller.updateThemeType(theme),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      theme == ThemeType.light ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      color: Theme.of(context).primaryColor
                    ),
                    const SizedBox(width: 10),
                    SText(
                      text: theme == ThemeType.light ? "Light Theme" : "Dark Theme",
                      size: Sizing.font(16),
                      weight: FontWeight.bold,
                      color: Theme.of(context).primaryColorLight
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Image.asset(
                    theme == ThemeType.light ? Media.lightMode : Media.darkMode,
                    width: MediaQuery.sizeOf(context).width
                  )
                ),
                const SizedBox(height: 10),
                SText(
                  text: theme.type,
                  size: Sizing.font(16),
                  weight: FontWeight.bold,
                  color: Theme.of(context).primaryColorLight
                ),
                SText(
                  text: theme == ThemeType.light
                    ? "Active when you want something brighter"
                    : "Eye-friendly design for low-light environment",
                  size: Sizing.font(14),
                  color: Theme.of(context).primaryColorLight
                ),
              ],
            )
          );
        });
      }
    );
  }
}