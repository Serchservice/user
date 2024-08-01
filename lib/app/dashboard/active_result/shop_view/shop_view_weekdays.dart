import 'package:user/library.dart';
import 'package:flutter/material.dart';

class ShopViewWeekdays extends StatelessWidget {
  final List<ShopWeekday> weekdays;
  const ShopViewWeekdays({super.key, required this.weekdays});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: weekdays.map((day) => Column(
        children: [
          Padding(
            padding: EdgeInsets.all(Sizing.space(12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SText.center(
                        text: day.day,
                        size: Sizing.font(15),
                        weight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SText.center(
                            text: day.opening,
                            size: Sizing.font(11),
                            color: Theme.of(context).primaryColor
                          ),
                          const SizedBox(width: 5),
                          SText.center(
                            text: "-",
                            size: Sizing.font(11),
                            color: Theme.of(context).primaryColor
                          ),
                          const SizedBox(width: 5),
                          SText.center(
                            text: day.closing,
                            size: Sizing.font(11),
                            color: Theme.of(context).primaryColor
                          ),
                        ],
                      )
                    ],
                  )
                ),
              ],
            ),
          ),
          Divider(color: Theme.of(context).primaryColor)
        ],
      )).toList(),
    );
  }
}