import 'package:flutter/material.dart';
import 'package:user/library.dart';

class HomeCategorySelector extends StatelessWidget {
  final SerchCategory category;

  const HomeCategorySelector({super.key, required this.category});

  static void open(SerchCategory category) => Navigate.bottomSheet(
    sheet: HomeCategorySelector(category: category),
    route: "/home/${category.type}/options",
    isScrollable: true
  );

  @override
  Widget build(BuildContext context) {
    List<ButtonView> actions = [
      ButtonView(
        icon: Icons.travel_explore_rounded,
        header: "Search for ${CommonUtility.textWithAorAn(category.type)} skill",
        index: 0
      ),
      ButtonView(
        icon: Icons.mode_of_travel_rounded,
        header: "Request for ${CommonUtility.textWithAorAn(category.type)}",
        index: 1,
      ),
      ButtonView(
        icon: Icons.call_split_rounded,
        header: "Speak to ${CommonUtility.textWithAorAn(category.type)}",
        index: 2,
      ),
      if(category.canDrive) ...[
        ButtonView(
          icon: Icons.drive_eta_rounded,
          header: "Drive to ${CommonUtility.textWithAorAn(category.type)} shop",
          index: 3,
        ),
      ]
    ];

    return CurvedBottomSheet(
      safeArea: true,
      padding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(Sizing.space(2)),
              margin: EdgeInsets.all(Sizing.space(6)),
              width: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(16)
              ),
            ),
            SText(
              text: "Pick the best mode you want",
              size: Sizing.font(16),
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor
            ),
            const SizedBox(height: 10),
            ...actions.map((action) {
              return CentreNavigator(
                tab: action,
                onTap: () {
                  AnalyticsEngine.logSelectContent(category.type, category.category, parameters: category.toJson());

                  if(action.index == 0) {
                    SkillSearchLayout.to(category: category);
                  } else if(action.index == 1) {
                    RequestEntryLayout.request(category: category);
                  } else if(action.index == 2) {
                    RequestEntryLayout.speak(category: category);
                  } else {
                    RequestEntryLayout.drive(category: category);
                  }
                },
              );
            })
          ],
        ),
      )
    );
  }
}