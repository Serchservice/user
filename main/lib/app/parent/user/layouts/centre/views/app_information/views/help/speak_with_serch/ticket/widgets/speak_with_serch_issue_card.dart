import 'package:bubble/bubble.dart';
import 'package:user/library.dart';
import 'package:flutter/material.dart';

class SpeakWithSerchIssueCard extends StatelessWidget {
  final Issue issue;

  const SpeakWithSerchIssueCard({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    return Bubble(
      color: issue.isSerch ? CommonColors.darkTheme2 : CommonColors.hint,
      nip: issue.isSerch ? BubbleNip.leftTop : BubbleNip.rightTop,
      margin: issue.isSerch ? BubbleEdges.only(left: 10, bottom: 6) : BubbleEdges.only(right: 7, bottom: 6),
      radius: const Radius.circular(10),
      alignment: issue.isSerch ? Alignment.topLeft : Alignment.topRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.7,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(!issue.isSerch) ...[
                  SText.center(text: issue.label, color: CommonColors.lightTheme2, size: Sizing.font(11)),
                  Avatar(radius: 14, avatar: ParentController.data.state.avatar.value)
                ],
                if(issue.isSerch) ...[
                  Image.asset(Media.logo, height: 50, color: CommonColors.lightTheme),
                  SText.center(text: issue.label, color: CommonColors.lightTheme2, size: Sizing.font(11)),
                ],
              ]
            ),
            Container(
              padding: const EdgeInsets.all(6),
              margin: const EdgeInsets.only(top: 6),
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(color: CommonColors.lightTheme2, borderRadius: BorderRadius.circular(6)),
              child: SText(text: issue.message, color: CommonColors.darkTheme, size: Sizing.font(14)),
            )
          ],
        )
      )
    );
  }
}