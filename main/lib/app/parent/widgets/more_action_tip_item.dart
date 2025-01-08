import 'package:user/library.dart';
import 'package:flutter/material.dart';

class MoreActionTipItem extends StatelessWidget {
  final ButtonView view;
  final double? imageHeight;
  final double? imageWidth;
  final double itemHeight;
  final double itemWidth;
  final Function(ButtonView) onTap;

  const MoreActionTipItem({
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
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Theme.of(context).appBarTheme.backgroundColor,
          child: InkWell(
            onTap: () => onTap.call(view),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.only(top: 24, bottom: 24, left: 8),
                    decoration: BoxDecoration(gradient: LinearGradient(colors: view.colors)),
                    child: Image(
                      image: AssetUtility.image(view.image),
                      height: imageHeight ?? 50,
                      width: imageWidth ?? 50,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SText(
                          text: view.header,
                          size: Sizing.font(14),
                          color: Theme.of(context).primaryColor,
                          weight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_right_alt_rounded,
                        size: Sizing.space(24),
                        color: Theme.of(context).primaryColorLight
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
