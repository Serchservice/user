import 'package:flutter/material.dart';
import 'package:user/library.dart';

class CallHistoryView extends StatelessWidget {
  final CallResponse call;
  const CallHistoryView({super.key, required this.call});

  static void open(CallResponse call) {
    Navigate.bottomSheet(
      sheet: CallHistoryView(call: call),
      isScrollable: true,
      safeArea: false,
      route: "/conversation/call/history?with=${call.member.member}"
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Call History with ${call.member.name}",
          size: Sizing.font(16),
          flow: TextOverflow.ellipsis,
          color: Theme.of(context).primaryColor
        ),
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
                    const SizedBox(height: 6),
                    SText.center(
                      text: call.member.category,
                      size: Sizing.font(16),
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
                  text: "Recent",
                  color: Theme.of(context).primaryColor,
                  size: Sizing.font(16),
                  weight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 5),
              _buildHistory(context: context, history: call.recent),
              if(call.history.isNotEmpty) ...[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SText(
                    text: "History",
                    color: Theme.of(context).primaryColor,
                    size: Sizing.font(16),
                    weight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 5),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: call.history.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return _buildHistory(
                      context: context,
                      history: call.history[index]
                    );
                  }
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistory({required BuildContext context, required CallHistory history}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => CallOptionSheet.open(
          name: call.member.name,
          id: call.member.member,
          avatar: call.member.avatar
        ),
        child: Padding(
          padding: EdgeInsets.all(Sizing.space(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getCallIcon(history),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SText(
                      text: history.label,
                      size: Sizing.font(14),
                      color: Theme.of(context).primaryColor,
                      flow: TextOverflow.ellipsis
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
                )
              ),
              const SizedBox(width: 6),
              Container(
                padding: EdgeInsets.all(Sizing.space(5)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).appBarTheme.backgroundColor,
                ),
                child: CategoryImage(
                  image: history.isVoice
                    ? Media.voiceCall
                    : history.isVideo
                    ? Media.videoCall
                    : Media.tip2fixCall,
                  width: 25,
                  height: 25
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}