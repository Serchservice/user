import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:user/library.dart';

class ChatRoomLoadingMessageCard extends StatelessWidget {
  final bool isNotUser;

  const ChatRoomLoadingMessageCard({super.key, required this.isNotUser});

  @override
  Widget build(BuildContext context) {
    return LoadingShimmer(
      content: Bubble(
        color: isNotUser ? CommonColors.darkTheme2 : CommonColors.hint,
        nip: isNotUser ? BubbleNip.leftTop : BubbleNip.rightTop,
        margin: isNotUser ? const BubbleEdges.only(left: 10, bottom: 6) : const BubbleEdges.only(right: 7, bottom: 6),
        radius: const Radius.circular(10),
        alignment: isNotUser ? Alignment.topLeft : Alignment.topRight,
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.7,),
          child: SizedBox(height: 70, width: MediaQuery.sizeOf(context).width * 0.7,)
        )
      ),
    );
  }
}