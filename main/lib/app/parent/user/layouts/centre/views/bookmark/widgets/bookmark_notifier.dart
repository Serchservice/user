import 'package:flutter/material.dart';
import 'package:user/library.dart';

class BookmarkNotifier extends StatelessWidget {
  const BookmarkNotifier({super.key});

  static void open() => Navigate.bottomSheet(sheet: BookmarkNotifier(), route: "/centre/bookmark/notice", isScrollable: true);

  @override
  Widget build(BuildContext context) {
    List<String> todos = [
      "Save your favorite providers to access their services faster and more conveniently.",
      "Easily reconnect with providers you trust without searching repeatedly.",
      "Use bookmarks to quickly start chats or service requests with providers you love.",
      "Keep your saved providers organized and accessible for whenever you need them.",
      "Enjoy a seamless experience by bookmarking and connecting with your preferred providers at any time."
    ];

    return CurvedBottomSheet(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Column(
          spacing: 10,
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
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.all(12),
              color: CommonUtility.lightenColor(Colors.purple, 45),
              child: Center(child: Image(image: AssetUtility.image(Media.commonBookmark), height: 220)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SText(
                    text: "Make Connections Easier with Bookmarks",
                    size: Sizing.font(20),
                    weight: FontWeight.bold,
                    color: Theme.of(context).primaryColor
                  ),
                  ...todos.map((todo) => Row(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.bookmark_added, color: Theme.of(context).primaryColor),
                      Expanded(child: SText(text: todo, size: 14.5, color: Theme.of(context).primaryColor))
                    ],
                  ))
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}