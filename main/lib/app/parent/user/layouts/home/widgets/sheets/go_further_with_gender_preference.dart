import 'package:user/library.dart';
import 'package:flutter/material.dart';

class GoFurtherWithGenderPreference extends StatelessWidget {
  final Color color;

  const GoFurtherWithGenderPreference({super.key, required this.color});

  static void open(Color color) => Navigate.bottomSheet(
    sheet: GoFurtherWithGenderPreference(color: color),
    route: "/home/go_further/gender",
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
                    image: AssetUtility.image(Media.commonGender),
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
                    text: "Take control, your way, with confidence and safety.",
                    size: Sizing.space(22),
                    weight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  Expanded(
                    child: SText(
                      text: [
                        "With the gender trip preference, you have the flexibility to decide which gender",
                        "you’d like to request their services. This feature empowers you to tailor your",
                        "experience, ensuring comfort and peace of mind while Serch tailors its results to you."
                      ].join(" "),
                      size: Sizing.space(12),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  LoadingButton(
                    text: "Coming soon",
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