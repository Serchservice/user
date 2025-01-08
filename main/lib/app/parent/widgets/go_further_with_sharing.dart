import 'package:user/library.dart';
import 'package:flutter/material.dart';

class GoFurtherWithSharing extends StatelessWidget {
  final Color color;

  const GoFurtherWithSharing({super.key, required this.color});

  static void open(Color color) => Navigate.bottomSheet(
    sheet: GoFurtherWithSharing(color: color),
    route: "/home/go_further/sharing",
    isScrollable: true
  );

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.zero,
      safeArea: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: color,
            width: MediaQuery.sizeOf(context).width,
            padding: EdgeInsets.all(12),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Material(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: InkWell(
                      onTap: () => Navigate.back(),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.close, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Image(
                    image: AssetUtility.image(Media.commonShare),
                    height: 220,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  SText(
                    text: "Empower collaboration, ensure satisfaction.",
                    size: Sizing.space(22),
                    weight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  Expanded(
                    child: SText(
                      text: [
                        "Seamlessly transfer your trip request to another provider when your current provider"
                         "can't seem to resolve your issue. With the your permission, the provider can connect"
                         "you to a trusted provider—whether offline or registered with Serch—ensuring your needs"
                         "are met while waiting for the replacement to arrive. You remain relaxed while you're"
                          "taken care of, with smooth transition and security all the way."
                      ].join(" "),
                      size: Sizing.space(12),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  LoadingButton(
                    text: "I understand",
                    autoSize: false,
                    borderRadius: 24,
                    onClick: () => Navigate.back(),
                    width: MediaQuery.sizeOf(context).width,
                    padding: EdgeInsets.all(12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}