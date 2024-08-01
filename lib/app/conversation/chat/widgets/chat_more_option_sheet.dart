import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ChatMoreOptionSheet extends StatelessWidget {
  final String name;
  final String id;
  final dynamic data;
  final String avatar;

  const ChatMoreOptionSheet({
    super.key,
    required this.name,
    required this.id,
    this.data,
    required this.avatar
  });

  static void open({required String id, required String name, dynamic data, required String avatar}) {
    Navigate.bottomSheet(
      sheet: ChatMoreOptionSheet(
        name: name,
        id: id,
        data: data,
        avatar: avatar
      ),
      route: "/conversation/chat?with=$id&scope=more"
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ButtonView> options = [
      ButtonView(header: "Invite $name", icon: Icons.input_rounded, index: 0),
      ButtonView(header: "Speak with $name", icon: Icons.call_rounded, path: Media.voiceCall, index: 1),
      ButtonView(header: "Tip2fix with $name", icon: Icons.call_merge_rounded, path: Media.tip2fixCall, index: 2),
      ButtonView(header: "Report $name", icon: Icons.report_rounded, index: 3),
    ];

    return CurvedBottomSheet(
      safeArea: true,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(Sizing.space(2)),
              margin: EdgeInsets.all(Sizing.space(12)),
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
              text: "More",
              size: Sizing.font(16),
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor
            ),
          ),
          const SizedBox(height: 20),
          ...options.map((option) {
            return CentreNavigator(
              tab: option,
              onTap: () {
                if(option.index == 0) {
                  Navigate.back();
                  ConversationActionView.open(provider: id, name: name);
                } else if(option.index == 1) {
                  // RouteNavigator.makeCall(name: name, avatar: avatar, user: id, type: CallType.voice);
                } else if(option.index == 2) {
                  // RouteNavigator.makeCall(name: name, avatar: avatar, user: id, type: CallType.tip2fix);
                } else {
                  ReportSheet.user(id: id, name: name, onSuccess: () => Navigate.all(HomeLayout.route));
                }
              },
              color: option.index == 3 ? CommonColors.error : null,
            );
          }).toList()
        ],
      )
    );
  }
}