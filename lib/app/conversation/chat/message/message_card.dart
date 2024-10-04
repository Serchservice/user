import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:user/library.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class MessageCard extends StatefulWidget {
  final ChatMessage message;
  final Function(ChatReply reply, ChatMessage message)? goToReplied;
  final bool haveNip;
  final ChatController controller;

  const MessageCard({
    super.key,
    required this.message,
    this.haveNip = true,
    required this.goToReplied,
    required this.controller,
  });

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  bool _showAsset = false;

  @override
  void initState() {
    bool showAsset = (widget.message.type.toLowerCase() == "audio"
        || widget.message.type.toLowerCase() == "image"
        || widget.message.type.toLowerCase() == "video")
        && (widget.message.message.isNotEmpty);

    setState(() {
      _showAsset = showAsset;
    });

    super.initState();
  }

  final GlobalKey _contentKey = GlobalKey();
  double _calculatedHeight = 50;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_contentKey.currentContext != null) {
        final RenderBox renderBox = _contentKey.currentContext!.findRenderObject() as RenderBox;
        setState(() {
          _calculatedHeight = renderBox.size.height;
        });
        widget.controller.updateMessageHeight(widget.message.id, _calculatedHeight);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _contentKey,
      child: Bubble(
        key: ValueKey(widget.message.id),
        color: widget.message.isSentByCurrentUser
            ? CommonColors.darkTheme2
            : CommonColors.lightTheme,
        margin: !widget.message.isSentByCurrentUser && !widget.haveNip
            ? const BubbleEdges.only(left: 10)
            : widget.message.isSentByCurrentUser && !widget.haveNip
            ? const BubbleEdges.only(right: 10)
            : !widget.message.isSentByCurrentUser && widget.haveNip
            ? const BubbleEdges.only(left: 7)
            : const BubbleEdges.only(right: 7),
        padding: widget.message.reply != null
            ? const BubbleEdges.all(5)
            : _showAsset
            ? const BubbleEdges.all(4)
            : null,
        radius: const Radius.circular(10),
        alignment: widget.message.isSentByCurrentUser
            ? Alignment.topRight
            : Alignment.topLeft,
        nip: widget.message.isSentByCurrentUser && widget.haveNip
            ? BubbleNip.rightTop
            : !widget.message.isSentByCurrentUser && widget.haveNip
            ? BubbleNip.leftTop
            : null,
        nipWidth: 5,
        elevation: 4,
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.7),
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if(widget.message.message.isEmpty)...[
                const SizedBox.shrink()
              ] else if (_showAsset) ...[
                _buildAsset(context: context, message: widget.message)
              ] else ...[
                _buildTextMessage(context: context, message: widget.message)
              ]
            ],
          )
        ),
      ),
    );
  }

  Widget _buildTextMessage({required BuildContext context, required ChatMessage message}) {
    return Stack(
      children: [
        Padding(
            padding: EdgeInsets.only(bottom: 14, right: message.reply != null ? 0 : 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(message.reply != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => widget.goToReplied?.call(message.reply!, message),
                        child: ReplyMessage(
                          reply: message.reply!,
                          margin: 1,
                          shouldFillWidth: false,
                          showCancel: false,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                SelectableLinkify(
                  options: const LinkifyOptions(humanize: false),
                  text: message.message,
                  style: TextStyle(
                    color: message.isSentByCurrentUser
                        ? CommonColors.lightTheme
                        : CommonColors.darkTheme,
                    fontSize: Sizing.font(14),
                  ),
                  onOpen: (link) => RouteNavigator.openLink(url: link.url),
                )
              ],
            )
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SText(
                text: message.label,
                color: CommonColors.hint,
                size: Sizing.font(11),
              ),
              if(message.isSentByCurrentUser)...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 1),
                    Icon(
                      message.status.toLowerCase() == "sending"
                          ? Icons.timelapse
                          : message.status.toLowerCase() == "read"
                          ? Icons.done_all_rounded
                          : Icons.done_rounded,
                      color: message.status.toLowerCase() == "sending"
                          ? CommonColors.hint
                          : CommonColors.lightTheme,
                      size: Sizing.font(12)
                    )
                  ]
                )
              ]
            ]
          )
        )
      ],
    );
  }

  Widget _buildAsset({required BuildContext context, required ChatMessage message}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(message.reply != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Material(
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: InkWell(
                onTap: () => widget.goToReplied?.call(message.reply!, message),
                child: ReplyMessage(
                  reply: message.reply!,
                  margin: 1,
                  shouldFillWidth: false,
                  showCancel: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
        ],
        if(message.type.toLowerCase() == "image")...[
          ImageMessage(message: message)
        ]
      ],
    );
  }
}