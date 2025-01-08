import 'package:flutter/material.dart';
import 'package:user/library.dart';

class CallChannelListItem extends StatelessWidget {
  final CallResponse call;

  const CallChannelListItem({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    CallHistory recent = call.history[0];
    String count = call.history.length > 1 ? "(${call.history.length})" : "";

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => CallChannelLayout.open(call),
        child: Padding(
          padding: EdgeInsets.all(Sizing.space(12)),
          child: Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Avatar.small(avatar: call.member.avatar),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SText(
                      text: "${call.member.name} $count",
                      size: Sizing.font(14),
                      color: Theme.of(context).primaryColor,
                      flow: TextOverflow.ellipsis
                    ),
                    Row(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        getCallIcon(recent),
                        Expanded(
                          child: SText(
                            text: recent.label,
                            size: Sizing.font(11),
                            color: Theme.of(context).primaryColorLight,
                            flow: TextOverflow.ellipsis
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ),
              getCallType(recent)
            ],
          ),
        )
      )
    );
  }

  static Icon getCallIcon(CallHistory history) {
    return Icon(
    history.outgoing && history.isMissed
        ? Icons.call_missed_outgoing_rounded
        : !history.outgoing && history.isMissed
        ? Icons.call_missed
        : history.isDeclined
        ? Icons.disabled_visible_outlined
        : !history.outgoing
        ? Icons.call_received_outlined
        : Icons.call_made_rounded,
      color: history.outgoing && history.isMissed
        ? CommonColors.premium
        : history.isMissed
        ? CommonColors.error
        : history.isDeclined
        ? CommonColors.hint
        : CommonColors.green,
      size: 18
    );
  }

  static Widget getCallType(CallHistory history, {double size = 25}) {
    return CategoryImage(
      image: history.isVoice
        ? Media.voiceCall
        : history.isVideo
        ? Media.videoCall
        : Media.tip2fixCall,
      width: size,
      height: size
    );
  }
}