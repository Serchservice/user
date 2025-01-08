import 'package:flutter/material.dart';
import 'package:user/library.dart';

class CallChannelLayout extends StatelessWidget {
  final CallResponse call;

  const CallChannelLayout({super.key, required this.call});

  static void open(CallResponse call) {
    Navigate.bottomSheet(
      sheet: CallChannelLayout(call: call),
      isScrollable: true,
      safeArea: false,
      route: "/connect?type=call_history&with=${call.member.member}"
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Call Info",
          size: Sizing.font(16),
          flow: TextOverflow.ellipsis,
          color: Theme.of(context).primaryColor
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image(
                image: AssetUtility.image(call.member.image),
                width: 40,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
      child: Scrollbar(
        thickness: 2.0,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Avatar.large(avatar: call.member.avatar),
                    const SizedBox(height: 10),
                    SText(
                      text: call.member.name,
                      size: Sizing.font(16),
                      color: Theme.of(context).primaryColor,
                      flow: TextOverflow.ellipsis
                    ),
                    SText.center(
                      text: call.member.category,
                      size: Sizing.font(13),
                      flow: TextOverflow.ellipsis,
                      color: Theme.of(context).primaryColor
                    )
                  ],
                )
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SText(
                  text: "Call history",
                  color: Theme.of(context).primaryColor,
                  size: Sizing.font(16),
                  weight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 5),
              if(call.history.isNotEmpty) ...[
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: call.history.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => CallChannelHistory(history: call.history[index])
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}