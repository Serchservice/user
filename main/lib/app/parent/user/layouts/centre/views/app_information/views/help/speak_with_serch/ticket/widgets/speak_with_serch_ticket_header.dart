import 'package:user/library.dart';
import 'package:flutter/material.dart';

class SpeakWithSerchTicketHeader extends StatelessWidget {
  final SpeakWithSerch? _message;

  const SpeakWithSerchTicketHeader({super.key, required SpeakWithSerch? message}) : _message = message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CommonColors.darkTheme2,
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.all(Sizing.space(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SText.center(
                  text: _message!.ticket,
                  color: Theme.of(context).primaryColorLight,
                  size: Sizing.font(12)),
                SText.center(
                  text: "Created At: ${_message.label}",
                  color: CommonColors.hint,
                  size: Sizing.font(12)
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SpeakWithSerchStatus(message: _message)
        ],
      )
    );
  }
}