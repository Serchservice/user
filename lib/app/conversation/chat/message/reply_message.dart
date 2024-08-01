import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ReplyMessage extends StatelessWidget {
  final ChatReply reply;
  final VoidCallback? onCancel;
  final double? margin;
  final bool shouldFillWidth;
  final bool showCancel;
  final Color? background;
  const ReplyMessage({
    super.key,
    required this.reply,
    this.onCancel,
    this.margin,
    required this.shouldFillWidth,
    required this.showCancel,
    this.background
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(Sizing.space(4)),
        margin: EdgeInsets.symmetric(vertical: margin ?? 5),
        width: shouldFillWidth ? Get.width : null,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: reply.isSentByCurrentUser
                ? CommonColors.yellow
                : CommonColors.allday,
              width: 6
            ),
            top: BorderSide.none,
            right: BorderSide.none,
            bottom: BorderSide.none,
          ),
          color: background ?? Theme.of(context).appBarTheme.backgroundColor
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context: context, reply: reply, showCancel: showCancel),
            const SizedBox(height: 8),
            _buildMessage(context: context, reply: reply)
            // Message
          ]
        ),
      ),
    );
  }

  Widget _buildHeader({required BuildContext context, required ChatReply reply, required bool showCancel}) {
    if(showCancel) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SText(
              text: reply.sender,
              size: Sizing.font(12),
              color: Theme.of(context).primaryColor,
              flow: TextOverflow.ellipsis,
            ),
          ),
          if(showCancel)...[
            GestureDetector(
              onTap: () => onCancel?.call(),
              child: Icon(
                Icons.close,
                size: Sizing.font(16),
                color: CommonColors.darkTheme2
              )
            )
          ]
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SText(
              text: reply.sender,
              size: Sizing.font(12),
              color: Theme.of(context).primaryColor,
              flow: TextOverflow.ellipsis,
            ),
          ),
        ]
      );
    }
  }

  Widget _buildMessage({required BuildContext context, required ChatReply reply}) {
    String buildText() {
      if(reply.type.toLowerCase() == "photo") {
        return "📷 Photo (${reply.fileSize})";
      } else if(reply.type.toLowerCase() == "video") {
        return "🎥 Video (${reply.duration}) - (${reply.fileSize})";
      } else if(reply.type.toLowerCase() == "audio") {
        return "🎵 Audio (${reply.duration}) - (${reply.fileSize})";
      } else if(reply.type.toLowerCase() == "voice") {
        return "🎵 Voice (${reply.duration}) - (${reply.fileSize})";
      } else if(reply.type.toLowerCase() == "file") {
        return "🗒️ File (${reply.fileSize})";
      } else {
        return reply.message;
      }
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SText(
            text: buildText(),
            size: Sizing.font(12),
            color: CommonColors.hint,
            flow: TextOverflow.ellipsis,
            lines: 1
          ),
        )
      ],
    );
  }
}