import 'package:user/library.dart';
import 'package:flutter/material.dart';

class AccountTipItem extends StatelessWidget {
  final ButtonView view;
  final double? imageHeight;
  final double? imageWidth;
  final double itemHeight;
  final double itemWidth;
  final Function(ButtonView) onTap;

  const AccountTipItem({
    super.key,
    required this.view,
    this.imageHeight,
    this.imageWidth,
    required this.itemHeight,
    required this.itemWidth,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemHeight,
      width: itemWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: view.color,
          child: InkWell(
            onTap: () => onTap.call(view),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          SText(
                            text: view.header,
                            size: Sizing.space(14),
                            weight: FontWeight.bold,
                            color: CommonColors.darkTheme
                          ),
                          SText(
                            text: view.body,
                            size: Sizing.space(12),
                            color: CommonColors.darkTheme
                          ),
                        ],
                      ),
                    ),
                  )
                ),
                Image(
                  image: AssetUtility.image(view.image),
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.cover,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
