import 'package:flutter/material.dart';
import 'package:user/library.dart';

class TripStep extends StatefulWidget {
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
    this.height,
    this.isVertical = true,
  });

  @override
  State<TripStep> createState() => _TripStepState();
}

class _TripStepState extends State<TripStep> {
  final GlobalKey _contentKey = GlobalKey();
  double _calculatedHeight = 50;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_contentKey.currentContext != null) {
        final RenderBox renderBox = _contentKey.currentContext!.findRenderObject() as RenderBox;
        setState(() {
          _calculatedHeight = renderBox.size.height; // Adjust with padding or margin if needed
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.isOver ? 1.0 : 0.4,
      child: widget.isVertical ? _buildVertical(context) : _buildHorizontal(context),
    );
  }

  Widget _buildHorizontal(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Sizing.space(2.5)),
      width: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(4),
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
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            if (widget.showBottom) ...[
              Container(
                height: Sizing.space(widget.height ?? _calculatedHeight),
                width: Sizing.space(1.5),
                color: Theme.of(context).primaryColor,
              ),
            ],
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          key: _contentKey,
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
                        text: widget.header,
                        color: Theme.of(context).primaryColor,
                        size: Sizing.font(14),
                        weight: FontWeight.bold,
                        flow: TextOverflow.clip,
                      ),
                    ),
                    const SizedBox(width: 20),
                    SText(
                      text: widget.label,
                      color: Theme.of(context).primaryColorLight,
                      size: Sizing.font(9),
                      flow: TextOverflow.clip,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SText(
                  text: widget.description,
                  color: Theme.of(context).primaryColor,
                  size: Sizing.font(9),
                  flow: TextOverflow.clip,
                ),
                if (widget.custom != null) ...[
                  widget.custom!,
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}