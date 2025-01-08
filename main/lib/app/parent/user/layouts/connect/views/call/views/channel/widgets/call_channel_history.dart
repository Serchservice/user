import 'package:flutter/material.dart';
import 'package:user/library.dart';

class CallChannelHistory extends StatelessWidget {
  final CallHistory history;

  const CallChannelHistory({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Sizing.space(12)),
      child: Row(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CallChannelListItem.getCallType(history),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 6,
                  children: [
                    Expanded(
                      child: SText(
                        text: history.outgoing ? "Outgoing" : "Incoming",
                        size: Sizing.font(14),
                        color: Theme.of(context).primaryColor,
                        flow: TextOverflow.ellipsis
                      ),
                    ),
                    if(history.duration.isNotEmpty) ...[
                      SText(
                        text: history.duration,
                        size: Sizing.font(11),
                        color: Theme.of(context).primaryColorLight,
                        flow: TextOverflow.ellipsis
                      )
                    ],
                  ],
                ),
                Row(
                  spacing: 6,
                  children: [
                    CallChannelListItem.getCallType(history, size: 10),
                    Expanded(
                      child: SText(
                        text: history.label,
                        size: Sizing.font(12),
                        color: Theme.of(context).primaryColorLight,
                        flow: TextOverflow.ellipsis
                      ),
                    ),
                  ],
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}
