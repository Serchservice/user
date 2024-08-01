import 'package:flutter/material.dart';
import 'package:user/library.dart';

class TripStep extends StatelessWidget {
  final String header;
  final String description;
  final String label;
  final bool isOver;
  final Widget? custom;
  final bool showBottom;
  final double? height;
  final bool isVertical;

  const TripStep({
    super.key,
    this.showBottom = true,
    required this.header,
    required this.description,
    required this.label,
    required this.isOver,
    this.custom,
    this.height = 50,
    this.isVertical = true,
  }) ;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isOver ? 1.0 : 0.4,
      child: isVertical ? _buildVertical(context) : _buildHorizontal(context),
    );
  }

  Widget _buildHorizontal(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Sizing.space(2.5)),
      width: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(4)
      ),
    );
  }

  Widget _buildVertical(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: Sizing.space(15),
              width: Sizing.space(1.5),
              color: Theme.of(context).primaryColor,
            ),
            Container(
              padding: EdgeInsets.all(Sizing.space(4)),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(1)
              ),
            ),
            if(showBottom) ...[
              Container(
                height: Sizing.space(height ?? 50),
                width: Sizing.space(1.5),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(Sizing.space(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SText(
                        text: header,
                        color: Theme.of(context).primaryColor,
                        size: Sizing.font(14),
                        weight: FontWeight.bold,
                        flow: TextOverflow.clip
                      ),
                    ),
                    const SizedBox(width: 20),
                    SText(
                      text: label,
                      color: Theme.of(context).primaryColorLight,
                      size: Sizing.font(9),
                      flow: TextOverflow.clip
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SText(
                  text: description,
                  color: Theme.of(context).primaryColor,
                  size: Sizing.font(9),
                  flow: TextOverflow.clip
                ),
                if(custom != null) ...[
                  custom!
                ]
              ],
            ),
          ),
        )
      ],
    );
  }
}
