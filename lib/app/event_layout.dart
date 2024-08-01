import 'package:flutter/material.dart';
import 'package:user/library.dart';

Widget? buildEventLayout(BuildContext context, List<ActiveEvent> events) {
  if(events.isNotEmpty) {
    double space = Sizing.space(8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: events.map((event) {
        bool isLast = events.length - 1 != events.indexOf(event);

        return Padding(
          padding: isLast
            ? EdgeInsets.symmetric(horizontal: space)
            : EdgeInsets.only(bottom: space, left: space, right: space),
          child: event
        );
      }).toList(),
    );
  } else {
    return null;
  }
}