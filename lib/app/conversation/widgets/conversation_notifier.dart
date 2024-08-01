import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user/library.dart';

class ConversationNotifier extends StatelessWidget {
  const ConversationNotifier({super.key});

  static void open() {
    Navigate.bottomSheet(
      sheet: const ConversationNotifier(),
      route: "/conversation/notice"
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(Sizing.space(2)),
              margin: EdgeInsets.all(Sizing.space(6)),
              alignment: Alignment.center,
              width: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(16)
              ),
            ),
          ),
          Center(
            child: SText.center(
              text: "What you should know",
              size: Sizing.font(16),
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor
            ),
          ),
          const SizedBox(height: 20),
          SText.center(
            text: "You can only see chats and calls made for the current day, month and year. This simply means that "
            "the chats and calls displayed are any conversation you've had for today, "
            "${DateFormat('EEEE MMMM d, y').format(DateTime.now())}.\n\n"
            "However, you might see any older conversations for any conversation you've had today, depending on whether "
            "you've had a conversation with the user/provider",
            color: Theme.of(context).primaryColor
          ),
        ],
      )
    );
  }
}