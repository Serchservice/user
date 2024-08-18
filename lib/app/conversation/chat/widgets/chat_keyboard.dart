import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ChatKeyboard extends StatelessWidget {
  final ChatController controller;
  const ChatKeyboard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isSwiped = controller.state.isSwiped.value;

      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if(isSwiped) ...[
              ReplyMessage(
                reply: controller.state.reply.value,
                shouldFillWidth: true,
                showCancel: true,
                onCancel: () => controller.cancelReplyMessage()
              )
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    focusNode: controller.focusNode,
                    style: TextStyle(fontSize: Sizing.font(15), color: Theme.of(context).primaryColor),
                    cursorColor: Theme.of(context).primaryColor,
                    controller: controller.textMessage,
                    maxLines: 5,
                    minLines: 1,
                    enabled: true,
                    textAlignVertical: TextAlignVertical.center,
                    maxLengthEnforcement: MaxLengthEnforcement.none,
                    textCapitalization: TextCapitalization.sentences,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Got something to say?",
                      hintStyle: TextStyle(fontSize: Sizing.font(14), color: CommonColors.hint),
                      border: InputBorder.none,
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: CommonColors.hint, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Theme.of(context).primaryColorDark, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                    onPressed: () => controller.send(context),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((states) {
                        if(controller.state.showSendButton.value) {
                          return Theme.of(context).primaryColor;
                        } else {
                          return Theme.of(context).appBarTheme.backgroundColor;
                        }
                      }),
                      overlayColor: WidgetStateProperty.resolveWith((states) {
                        return CommonColors.shimmerBase.withOpacity(.48);
                      }),
                      shape: WidgetStateProperty.all(const CircleBorder()),
                    ),
                    tooltip: "Send",
                    icon: Icon(
                      Icons.arrow_upward_rounded,
                      color: controller.state.showSendButton.value
                          ? Theme.of(context).scaffoldBackgroundColor
                          : CommonColors.hint,
                      size: Sizing.space(22)
                    )
                ),
                if(controller.state.showScrollButton.value) ...[
                  IconButton(
                    onPressed: controller.scrollToEnd,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((states) {
                        return CommonColors.darkTheme2;
                      }),
                      overlayColor: WidgetStateProperty.resolveWith((states) {
                        return CommonColors.shimmerBase.withOpacity(.48);
                      }),
                      shape: WidgetStateProperty.all(const CircleBorder()),
                    ),
                    tooltip: "Scroll down",
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: CommonColors.lightTheme,
                      size: Sizing.space(22)
                    )
                  )
                ],
              ],
            ),
          ],
        ),
      );
    });
  }
}
