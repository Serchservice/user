import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user/library.dart';

class ConnectNotifier extends StatelessWidget {
  const ConnectNotifier({super.key});

  static void open() {
    Navigate.bottomSheet(sheet: const ConnectNotifier(), route: "/connect/notice", isScrollable: true);
  }

  @override
  Widget build(BuildContext context) {
    List<ButtonView> todos = [
      if(PlatformEngine.instance.isWeb) ...[
        ButtonView(
          body: "Currently, call is only accessible on mobile only",
          icon: CupertinoIcons.nosign
        ),
      ],
      ButtonView(
        body: "Chats and calls are secured with end-to-end encryption.",
        icon: CupertinoIcons.lock_shield_fill
      ),
      ButtonView(
        body: "You can only see chats and calls made for the current day, month and year. This simply means that "
            "the chats and calls displayed are any conversation you've had for today, "
            "${DateFormat('EEEE MMMM d, y').format(DateTime.now())}.",
        icon: CupertinoIcons.bubble_left_bubble_right_fill
      ),
      ButtonView(
        body: "You might see any older conversations for any conversation you've had today, depending on whether "
            "you've had a conversation with the user/provider",
        icon: CupertinoIcons.exclamationmark_bubble_fill
      ),
      ButtonView(
        body: "When you bookmark a provider, the chat logs remain in your history for easy communication and faster response time",
        icon: CupertinoIcons.bookmark_solid
      ),
      ButtonView(
        body: "Maximize extra data security checks for your chats in your Centre -> Preference settings",
        icon: CupertinoIcons.shield_lefthalf_fill
      ),
    ];

    return CurvedBottomSheet(
      padding: EdgeInsets.zero,
      safeArea: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: CommonUtility.lightenColor(CommonColors.yellow, 30),
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
                        color: CommonColors.darkTheme,
                        borderRadius: BorderRadius.circular(16)
                      ),
                    ),
                  ),
                  Center(
                    child: Image(
                      image: AssetUtility.image(Media.commonConnect),
                      height: 220,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: SText.center(
                text: "Connect, knowing you are secure and privacy-protected",
                size: Sizing.font(20),
                weight: FontWeight.bold,
                color: Theme.of(context).primaryColor
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: todos.map((todo) => Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(todo.icon, color: Theme.of(context).primaryColor),
                    Expanded(child: SText(text: todo.body, size: 14.5, color: Theme.of(context).primaryColor))
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