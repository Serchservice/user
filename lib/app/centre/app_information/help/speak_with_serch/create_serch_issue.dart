import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:user/library.dart';

class CreateSerchIssue extends StatefulWidget {
  final SpeakWithSerch? message;
  final SpeakWithSerchController controller;
  const CreateSerchIssue({super.key, this.message, required this.controller});

  @override
  State<CreateSerchIssue> createState() => _CreateSerchIssueState();

  static void open({required SpeakWithSerchController controller, SpeakWithSerch? message}) {
    Get.bottomSheet(
      CreateSerchIssue(message: message, controller: controller),
      backgroundColor: Colors.transparent,
      isScrollControlled: message != null,
      ignoreSafeArea: message == null,
      settings: RouteSettings(
        name: message != null
          ? "/centre/app/help/speak-with-serch/${message.ticket}"
          : "/centre/app/help/speak-with-serch/new",
      )
    );
  }
}

class _CreateSerchIssueState extends State<CreateSerchIssue> {
  final TextEditingController _messageController = TextEditingController();

  final ConnectService _connect = Connect();

  bool _isSending = false;
  SpeakWithSerch? _message;

  @override
  void initState() {
    if(widget.message != null) {
      setState(() {
        _message = widget.message;
      });
    }

    markRead();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    if(_messageController.text.isEmpty) {
      return;
    } else {
      CommonUtility.unfocus(context);
      setState(() {
        _isSending = true;
      });
      var response = await _connect.post(
          endpoint: "/company/speak_with_serch",
          body: {
            "ticket": _message?.ticket != null ? _message!.ticket : "",
            "comment": _messageController.text.trim()
          }
      );
      setState(() {
        _isSending = false;
      });
      if(response.isOk) {
        SpeakWithSerch message = SpeakWithSerch.fromJson(response.data);
        setState(() {
          _message = message;
        });
        widget.controller.homeController.messaging.loadSpeakWithSerchMessages();
        _messageController.clear();
      }
    }
  }

  void markRead() async {
    if(_message != null) {
      var response = await _connect.patch(endpoint: "/company/speak_with_serch/${_message?.ticket}", body: {});
      if(response.isOk) {
        widget.controller.homeController.messaging.updateSpeakWithSerch(response);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      padding: _message != null ? EdgeInsets.zero : null,
      safeArea: _message != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(_message != null) ...[
            CreateSerchIssueHeader(message: _message),
            const SizedBox(height: 10),
            Expanded(
              child: Scrollbar(
                thickness: 2.0,
                child: PageStorage(
                  bucket: PageStorageBucket(),
                  child: ListView.builder(
                    key: PageStorageKey(_message!.ticket),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: Sizing.space(8)),
                    itemCount: _message!.issues.length,
                    itemBuilder: (context, index) {
                      return CreateSerchIssueMessage(
                        issue: _message!.issues[index],
                        widget: widget
                      );
                    }
                  ),
                )
              )
            )
          ],
          if(_message == null) ...[
            Expanded(
              child: Center(
                child: SText.center(
                  text: "Start issue",
                  color: Theme.of(context).primaryColor,
                  size: Sizing.font(16)
                ),
              ),
            )
          ],
          Padding(
            padding: _message != null ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Field(
                    controller: _messageController,
                    padding: const EdgeInsets.all(10),
                    inputAction: TextInputAction.newline,
                    isBig: true,
                  ),
                ),
                const SizedBox(width: 10),
                LoadingButton(
                  text: "Send",
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizing.space(6),
                    vertical: Sizing.space(12)
                  ),
                  loading: _isSending,
                  onClick: () => sendMessage(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CreateSerchIssueMessage extends StatelessWidget {
  const CreateSerchIssueMessage({
    super.key,
    required this.issue,
    required this.widget,
  });

  final Issue issue;
  final CreateSerchIssue widget;

  @override
  Widget build(BuildContext context) {
    return Bubble(
      color: issue.isSerch
        ? CommonColors.darkTheme2
        : CommonColors.hint,
      nip: issue.isSerch
        ? BubbleNip.leftTop
        : BubbleNip.rightTop,
      margin: issue.isSerch
        ? const BubbleEdges.only(left: 10, bottom: 6)
        : const BubbleEdges.only(right: 7, bottom: 6),
      radius: const Radius.circular(10),
      alignment: issue.isSerch
        ? Alignment.topLeft
        : Alignment.topRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(!issue.isSerch) ...[
                  SText.center(
                    text: issue.label,
                    color: CommonColors.lightTheme2,
                    size: Sizing.font(11)
                  ),
                  Avatar(
                    radius: 14,
                    avatar: widget.controller.homeController.state.avatar.value
                  )
                ],
                if(issue.isSerch) ...[
                  Image.asset(
                    Media.logo,
                    height: 50,
                    color: CommonColors.lightTheme
                  ),
                  SText.center(
                    text: issue.label,
                    color: CommonColors.lightTheme2,
                    size: Sizing.font(11)
                  ),
                ],
              ]
            ),
            Container(
              padding: const EdgeInsets.all(6),
              margin: const EdgeInsets.only(top: 6),
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: CommonColors.lightTheme2,
                borderRadius: BorderRadius.circular(6)
              ),
              child: SText(
                text: issue.message,
                color: CommonColors.darkTheme,
                size: Sizing.font(14)
              ),
            )
          ],
        )
      )
    );
  }
}

class CreateSerchIssueHeader extends StatelessWidget {
  const CreateSerchIssueHeader({
    super.key,
    required SpeakWithSerch? message,
  }) : _message = message;

  final SpeakWithSerch? _message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CommonColors.darkTheme2,
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.all(Sizing.space(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SText.center(
                  text: _message!.ticket,
                  color: Theme.of(context).primaryColorLight,
                  size: Sizing.font(12)
                ),
                SText.center(
                  text: "Created At: ${_message!.label}",
                  color: CommonColors.hint,
                  size: Sizing.font(12)
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          CreateIssueStatus(message: _message!)
        ],
      )
    );
  }
}

class CreateIssueStatus extends StatelessWidget {
  final SpeakWithSerch message;
  const CreateIssueStatus({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Sizing.space(4)),
      decoration: BoxDecoration(
        color: message.isClosed
          ? CommonColors.error
          : message.isResolved
          ? CommonColors.success
          : CommonColors.hint,
        borderRadius: BorderRadius.circular(6)
      ),
      child: SText.center(
        text: message.status,
        color: CommonColors.lightTheme,
        size: Sizing.font(12)
      ),
    );
  }
}