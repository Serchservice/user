import 'package:flutter/material.dart';
import 'package:user/library.dart';

class SharedLinkNotifier extends StatelessWidget {
  const SharedLinkNotifier({super.key});

  static void open() {
    Navigate.bottomSheet(sheet: SharedLinkNotifier(), route: "/centre/account/shared_links/notice", isScrollable: true);
  }

  @override
  Widget build(BuildContext context) {
    List<String> todos = [
      "Use Shared Links to refer trusted providers to your friends and family, and earn money for every successful guest request.",
      "Generate a unique link for a provider and share it easily via your favorite platforms.",
      "Help your favorite providers grow their business while benefiting financially from your referrals.",
      "Track the requests generated through your shared links to stay informed about your earnings.",
      "Remember, your referral helps guests connect with reliable providers without needing to create an account."
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
              color: CommonUtility.lightenColor(CommonColors.allday, 60),
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.all(12),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(Sizing.space(2)),
                      margin: EdgeInsets.all(Sizing.space(6)),
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
                      image: AssetUtility.image(Media.commonSharedLink),
                      height: 220,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: SText.center(
                text: "Earn with Shared Link Referrals",
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
                    Icon(Icons.grain_rounded, color: Theme.of(context).primaryColor),
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