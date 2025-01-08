import 'package:flutter/material.dart';
import 'package:user/library.dart';

class AccountNotifier extends StatelessWidget {
  const AccountNotifier({super.key});

  static void open() => Navigate.bottomSheet(sheet: AccountNotifier(), route: "/centre/account/notice", isScrollable: true);

  @override
  Widget build(BuildContext context) {
    List<String> todos = [
      "Note that the portal for profile update opens once every year.",
      "As we are dedicated to making our platforms easy to use, we also value honesty in data, so always provide your correct data.",
      "We reserve the right to suspend your account if your data is not legally correct."
    ];

    return CurvedBottomSheet(
      padding: EdgeInsets.zero,
      safeArea: true,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: CommonUtility.lightenColor(Colors.purple, 30),
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.all(12),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(Sizing.space(2)),
                      margin: EdgeInsets.all(Sizing.space(2)),
                      alignment: Alignment.center,
                      width: 60,
                      decoration: BoxDecoration(
                        color: CommonColors.lightTheme,
                        borderRadius: BorderRadius.circular(16)
                      ),
                    ),
                  ),
                  Center(
                    child: Image(
                      image: AssetUtility.image(Media.commonAccount),
                      height: 220,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: SText.center(
                text: "Give integrity to your account information",
                size: Sizing.font(20),
                weight: FontWeight.bold,
                color: Theme.of(context).primaryColor
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: todos.map((todo) => Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.supervised_user_circle_rounded, color: Theme.of(context).primaryColor),
                    Expanded(child: SText(text: todo, size: 14.5, color: Theme.of(context).primaryColor))
                  ],
                )).toList(),
              ),
            )
          ],
        ),
      )
    );
  }
}