import 'package:user/library.dart';
import 'package:flutter/material.dart';

class SpeakWithSerchItem extends StatelessWidget {
  final SpeakWithSerch message;

  const SpeakWithSerchItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: InkWell(
        onTap: () => SpeakWithSerchTicketLayout.open(message: message),
        child: Padding(
          padding: EdgeInsets.all(Sizing.space(16)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SText(
                      text: message.ticket,
                      size: Sizing.font(15),
                      weight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ),
                    SpeakWithSerchStatus(message: message),
                  ],
                )
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SText(
                    text: message.time,
                    size: Sizing.font(12),
                    color: Theme.of(context).primaryColorLight
                  ),
                  const SizedBox(height: 10),
                  if(message.issues.any((element) => !element.isRead)) ...[
                    HeartBeating(
                      child: Container(
                        padding: EdgeInsets.all(Sizing.space(3)),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle
                        ),
                      ),
                    )
                  ]
                ]
              )
            ],
          ),
        )
      )
    );
  }
}