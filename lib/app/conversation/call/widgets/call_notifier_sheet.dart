import 'package:flutter/material.dart';
import 'package:user/library.dart';

class CallNotifierSheet extends StatelessWidget {
  final String channel;
  final String message;
  final String asset;

  const CallNotifierSheet({super.key, required this.channel, required this.message, required this.asset});

  static void open({required String channel, required String message, required String asset}) {
    Navigate.bottomSheet(
      sheet: CallNotifierSheet(channel: channel, message: message, asset: asset),
      route: "/call/$channel/error-information",
      isScrollable: true,
      safeArea: false
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Theme.of(context).textSelectionTheme.selectionColor,
            child: Column(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SText(
                          text: "Call Notification - $channel",
                          size: Sizing.font(16),
                          weight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          flow: TextOverflow.ellipsis
                        ),
                      ),
                      const SizedBox(width: 30),
                      Image.asset(
                        asset,
                        width: 30,
                        color: Theme.of(context).primaryColor,
                        height: 30
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          SText(
            text: message,
            size: Sizing.font(16),
            weight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}