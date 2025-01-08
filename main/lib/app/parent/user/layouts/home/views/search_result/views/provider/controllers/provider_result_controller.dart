import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ProviderResultController extends GetxController {
  final Active active;

  ProviderResultController({required this.active});
  final state = ProviderResultState();

  List<ButtonView> get buttons => [
    ButtonView(header: "Reserve ${active.name}", index: 1, icon: Icons.calendar_month),
    if(PlatformEngine.instance.isMobile) ...[
      ButtonView(header: "Chat with ${active.name}", index: 2, icon: CupertinoIcons.bubble_left_bubble_right_fill),
      ButtonView(header: "Call ${active.name}", index: 3, icon: CupertinoIcons.phone_circle_fill)
    ]
  ];

  void onClick(ButtonView view) {
    if(view.index == 1) {
      ScheduleTimePicker.open(
        id: active.id,
        name: active.name,
        onSchedule: (schedule) {
          Navigate.offTill(ParentLayout.route, ModalRoute.withName(ParentLayout.route));
        }
      );
    } else if(view.index == 2) {
      ChatRoomLayout.chat(roommate: active.id, removeRoute: true);
    } else {
      CallOptionSheet.open(name: active.name, id: active.id, avatar: active.avatar);
    }
  }
}