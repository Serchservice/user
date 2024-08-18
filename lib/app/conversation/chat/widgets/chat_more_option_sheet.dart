import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ChatMoreOptionSheet extends StatelessWidget {
  final ChatRoom room;
  const ChatMoreOptionSheet({super.key, required this.room});

  static void open({required ChatRoom room}) {
    Navigate.bottomSheet(
      sheet: ChatMoreOptionSheet(room: room),
      route: "/conversation/chat?with=${room.room}&scope=more"
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ButtonView> options = [
      ButtonView(header: "Invite", icon: Icons.input_rounded, index: 0),
      ButtonView(header: "Voice call", icon: Icons.call_rounded, path: Media.voiceCall, index: 1),
      ButtonView(header: "Tip2fix", icon: Icons.call_merge_rounded, path: Media.tip2fixCall, index: 2),
      ButtonView(header: "Report", icon: Icons.report_rounded, index: 3),
    ];

    return CurvedBottomSheet(
      safeArea: true,
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(24),
      child: SingleChildScrollView(
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SText(
                                    text: room.name,
                                    size: Sizing.font(16),
                                    weight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                    flow: TextOverflow.ellipsis
                                  ),
                                  const SizedBox(width: 6),
                                  if(room.isActive) ...[
                                    HeartBeating(child: Container(padding: const EdgeInsets.all(3), color: CommonColors.green))
                                  ]
                                ],
                              ),
                              SText(
                                text: room.trip,
                                size: Sizing.font(12),
                                color: Theme.of(context).primaryColor,
                                flow: TextOverflow.ellipsis
                              ),
                              SText(
                                text: "Last Seen: ${room.lastSeen}",
                                size: Sizing.font(12),
                                color: Theme.of(context).primaryColor,
                                flow: TextOverflow.ellipsis
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 30),
                        Image.asset(Media.serchChat, width: 50, height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 20),
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 5,
                runSpacing: 20,
                children: options.map((option) {
                  return SizedBox(
                    width: 75,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if(option.index == 0) {
                              Navigate.back();
                              ConversationActionView.open(provider: room.roommate, name: room.name);
                            } else if(option.index == 1) {
                              RouteNavigator.makeCall(name: room.name, avatar: room.avatar, user: room.roommate, type: CallType.voice);
                            } else if(option.index == 2) {
                              RouteNavigator.makeCall(name: room.name, avatar: room.avatar, user: room.roommate, type: CallType.tip2fix);
                            } else {
                              ReportSheet.user(id: room.roommate, name: room.name, onSuccess: () => Navigate.all(HomeLayout.route));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    option.icon,
                                    color: Theme.of(context).primaryColorDark,
                                    size: 18,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: SText.center(
                                          text: option.header,
                                          color: option.index == 3 ? CommonColors.error : Theme.of(context).primaryColor,
                                          size: Sizing.font(12),
                                          flow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      )
    );
  }
}