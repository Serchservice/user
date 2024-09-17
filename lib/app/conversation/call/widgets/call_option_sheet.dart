import 'package:flutter/material.dart';
import 'package:user/library.dart';

class CallOptionSheet extends StatelessWidget {
  final String name;
  final String id;
  final String avatar;

  const CallOptionSheet({super.key, required this.name, required this.id, required this.avatar});

  static void open({required String id, required String name, required String avatar}) {
    Navigate.bottomSheet(
      sheet: CallOptionSheet(name: name, id: id, avatar: avatar),
      route: "/conversation/call/start/options"
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ButtonView> options = [
      ButtonView(
        header: "Voice call",
        icon: Icons.call_rounded,
        body: "Start a voice call with $name",
        path: Media.voiceCall,
        index: 0
      ),
      ButtonView(
        header: "Tip2Fix",
        icon: Icons.tips_and_updates_rounded,
        body: "Start tip2fix with $name",
        path: Media.tip2fixCall,
        index: 1
      ),
    ];

    return CurvedBottomSheet(
      safeArea: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
              text: "Which call option do you prefer with $name?",
              size: Sizing.font(16),
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: options.length,
              crossAxisSpacing: 10,
              mainAxisExtent: 100,
            ),
            itemCount: options.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final option = options[index];
              return PreferenceBox(
                isSelected: false,
                onTap: () {
                  if(index == 0) {
                    RouteNavigator.makeCall(name: name, avatar: avatar, user: id, type: CallType.voice);
                  } else if(option.index == 1) {
                    RouteNavigator.makeCall(name: name, avatar: avatar, user: id, type: CallType.tip2fix);
                  }
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        option.path,
                        width: MediaQuery.of(context).size.width
                      )
                    ),
                    SText(
                      text: option.header,
                      size: Sizing.font(14),
                      weight: FontWeight.bold,
                      color: Theme.of(context).primaryColorLight
                    ),
                    // const SizedBox(height: 10),
                    // SText.center(
                    //   text: option.body,
                    //   size: Sizing.font(12),
                    //   color: Theme.of(context).primaryColorLight
                    // ),
                  ],
                )
              );
            }
          )
        ],
      )
    );
  }
}