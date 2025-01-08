import 'package:user/library.dart';
import 'package:flutter/material.dart';

class GuestAccountTrustSheet extends StatelessWidget {
  final Color color;

  const GuestAccountTrustSheet({super.key, required this.color});

  static void open(Color color) => Navigate.bottomSheet(
    sheet: GuestAccountTrustSheet(color: color),
    route: "/guest/home/account_trust_toolkit",
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
                    image: AssetUtility.image(Media.commonAccountTrust),
                    height: 220,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    SText(
                      text: "Your toolkit for a trustworthy account.",
                      size: Sizing.space(22),
                      weight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ),
                    SText(
                      text: [
                        "A trusted account, provides more credibility and assurance to providers when they see your request",
                        "There are several things you need to do on your end, to provide an edge for yourself."
                      ].join(" "),
                      size: Sizing.space(12),
                      color: Theme.of(context).primaryColor
                    ),
                    _buildRating(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRating(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context: context, title: "Rating"),
        _buildDescription(
          context: context,
          content: [
            "Rating tells a lot about an account like yours. Your rating provides a level of trust to",
            "providers on what to expect from your account anytime, any day."
          ]
        ),
      ],
    );
  }

  Widget _buildHeader({required BuildContext context, required String title}) {
    return SText(
      text: title,
      size: Sizing.space(14),
      weight: FontWeight.w600,
      color: Theme.of(context).primaryColor
    );
  }

  Widget _buildDescription({required BuildContext context, required List<String> content}) {
    return SText(
      text: content.join(" "),
      size: Sizing.space(12),
      color: Theme.of(context).primaryColor
    );
  }
}