import 'package:user/library.dart';
import 'package:flutter/material.dart';

class CentreAppDownloadSection extends StatelessWidget {
  final CentreController controller;

  const CentreAppDownloadSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if(PlatformEngine.instance.isWeb) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SText(
              text: "It is more easier in the app",
              size: Sizing.font(14),
              color: Theme.of(context).primaryColorLight
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CentreNavigator(
                tab: ButtonView(
                  header: "Download the Serch app",
                  body: "Click to download from your favorite stores",
                  image: Media.appUser
                ),
                onTap: controller.onAppDownload,
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.all(6)
              ),
            )
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
