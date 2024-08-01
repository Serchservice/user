import 'package:flutter/material.dart';
import 'package:user/library.dart';

class DashboardCategoryOptionSelector extends StatelessWidget {
  final SerchCategory category;
  const DashboardCategoryOptionSelector({super.key, required this.category});

  static void open(SerchCategory category) => Navigate.bottomSheet(
    sheet: DashboardCategoryOptionSelector(category: category),
    route: "/dashboard/${category.type}/options",
    isScrollable: true
  );

  @override
  Widget build(BuildContext context) {
    List<ButtonView> actions = [
      ButtonView(
        icon: Icons.travel_explore_rounded,
        header: "Search for ${CommonUtility.textWithAorAn(category.type)} skill",
        path: SkillSearchLayout.route,
        index: 0
      ),
      ButtonView(
        icon: Icons.mode_of_travel_rounded,
        header: "Request for ${CommonUtility.textWithAorAn(category.type)}",
        index: 1,
        path: RequestActionLayout.route,
      ),
      ButtonView(
        icon: Icons.call_split_rounded,
        header: "Speak to ${CommonUtility.textWithAorAn(category.type)}",
        index: 2,
        path: RequestActionLayout.route,
      ),
      if(category.canDrive) ...[
        ButtonView(
          icon: Icons.drive_eta_rounded,
          header: "Drive to ${CommonUtility.textWithAorAn(category.type)} shop",
          index: 3,
          path: RequestActionLayout.route,
        ),
      ]
    ];

    return CurvedBottomSheet(
      safeArea: true,
      padding: EdgeInsets.zero,
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
                  if(action.index == 0) {
                    Navigate.to(
                      action.path,
                      parameters: {"type": category.type, "category": category.category,},
                      arguments: category.toJson()
                    );
                  } else {
                    RouteNavigator.openRequestAction(
                      category: category,
                      request: category.copyWith(category: action.index == 1 ? "REQUEST" : action.index == 2 ? "SPEAK" : "DRIVE")
                    );
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