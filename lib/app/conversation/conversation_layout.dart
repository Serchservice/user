import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ConversationLayout extends GetResponsiveView<HomeController> {
  ConversationLayout({super.key});

  @override
  Widget build(BuildContext context) {
    List<ButtonView> tabs = [
      ButtonView(icon: Icons.chat, header: "Chats"),
      ButtonView(icon: Icons.call_made_rounded, header: "Calls"),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: MainLayout(
        appbar: AppBar(
          elevation: 0.5,
          title: SText.center(
            text: "Conversation",
            size: Sizing.font(20),
            weight: FontWeight.bold,
            color: Theme.of(context).primaryColor
          ),
          actions: [
            IconButton(
              onPressed: ConversationNotifier.open,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  return Colors.transparent;
                }),
                overlayColor: WidgetStateProperty.resolveWith((states) {
                  return CommonColors.shimmerBase.withOpacity(.48);
                }),
                shape: WidgetStateProperty.all(const CircleBorder()),
              ),
              tooltip: "Learn more",
              icon: Icon(
                Icons.info_outline_rounded,
                color: Theme.of(context).primaryColor,
                size: Sizing.space(22)
              )
            )
          ],
          bottom: TabBar.secondary(
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColorLight,
            unselectedLabelColor: CommonColors.hint,
            dividerColor: Colors.transparent,
            tabs: tabs.map((tab) => Tab(
              text: tab.header,
            )).toList()
          ),
        ),
        child: TabBarView(
          children: [
            ChatHistoryLayout(controller: controller),
            CallHistoryLayout(controller: controller),
          ],
        ),
      ),
    );
  }
}