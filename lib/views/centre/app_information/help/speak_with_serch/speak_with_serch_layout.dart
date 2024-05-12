import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class SpeakWithSerchLayout extends GetResponsiveView<SpeakWithSerchController> {
  static const String route = "/centre/app/help/speak-with-serch";
  SpeakWithSerchLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Speak With Serch",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      floatingButton: FloatingActionButton(
        onPressed: () => CreateSerchIssue.open(controller: controller),
        tooltip: "Create issue",
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        child: Icon(
          FontAwesomeIcons.penToSquare,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: Obx(() {
        if(controller.homeController.state.speakWithSerch.isNotEmpty) {
          List<SpeakWithSerch> messages = controller.homeController.state.speakWithSerch;
          messages.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
          return Scrollbar(
            thickness: 2.0,
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: Sizing.space(8)),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Material(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: InkWell(
                    onTap: () => CreateSerchIssue.open(
                      controller: controller,
                      message: message
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(Sizing.space(16)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SText(
                                  text: message.ticket,
                                  size: Sizing.font(15),
                                  weight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor
                                ),
                                CreateIssueStatus(message: message),
                              ],
                            )
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SText(
                                text: message.time,
                                size: Sizing.font(12),
                                color: Theme.of(context).primaryColorLight
                              ),
                              const SizedBox(height: 10),
                              if(message.issues.any((element) => !element.isRead)) ...[
                                  HeartBeating(
                                    child: Container(
                                      padding: EdgeInsets.all(Sizing.space(3)),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        shape: BoxShape.circle
                                      ),
                                    ),
                                  )
                                ]
                            ]
                          )
                        ],
                      ),
                    )
                  )
                );
              }
            )
          );
        } else {
          return Center(
            child: SText.center(
              text: "Tell Serch what the problem is",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(16)
            ),
          );
        }
      }),
    );
  }
}