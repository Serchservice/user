import 'package:flutter/material.dart';
import 'package:user/library.dart';

class GuestAccountNotifier extends StatelessWidget {
  const GuestAccountNotifier({super.key});

  static void open() => Navigate.bottomSheet(sheet: GuestAccountNotifier(), route: "/guest/centre/account/notice", isScrollable: true);

  @override
  Widget build(BuildContext context) {
    List<String> todos = [
      "As a guest, you cannot update your profile information. If you have a user account linked to this account, your changes in the user account will be reflected here.",
      "Your data is temporarily saved, meaning that when the link expires, your data might be removed if it is not linked to a user account.",
      "When you data is removed, your guest credentials still remain within the system for any future activity",
      "We reserve the right to suspend your account if your data is not legally correct."
    ];

    return CurvedBottomSheet(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(Sizing.space(2)),
                margin: EdgeInsets.all(Sizing.space(6)),
                alignment: Alignment.center,
                width: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(16)
                ),
              ),
            ),
            Center(
              child: SText.center(
                text: "What you should know",
                size: Sizing.font(16),
                weight: FontWeight.bold,
                color: Theme.of(context).primaryColor
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            ...todos.map((todo) {
              bool isBottom = todo == todos[todos.length - 1];

              return StepItem(title: todo, showBottom: !isBottom);
            })
          ],
        ),
      )
    );
  }
}