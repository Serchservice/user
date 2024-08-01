import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ReportSheet extends StatefulWidget {
  final String id;
  final String name;
  final bool isUser;
  final Function()? onSuccess;
  final Function()? onError;
  const ReportSheet({
    super.key,
    required this.id,
    required this.name,
    required this.isUser,
    this.onSuccess,
    this.onError
  });

  static void user({
    Function()? onSuccess,
    Function()? onError,
    required String name,
    required String id
  }) => Navigate.bottomSheet(
    sheet: ReportSheet(
      onSuccess: onSuccess,
      onError: onError,
      name: name,
      id: id,
      isUser: true,
    ),
    route: "/account/report",
    isScrollable: true,
  );

  static void shop({
    Function()? onSuccess,
    Function()? onError,
    required String name,
    required String id
  }) => Navigate.bottomSheet(
    sheet: ReportSheet(
      onSuccess: onSuccess,
      onError: onError,
      name: name,
      id: id,
      isUser: false,
    ),
    route: "/shop/report",
    isScrollable: true,
  );

  @override
  State<ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<ReportSheet> {
  final ConnectService _service = Connect();
  bool isReporting = false;

  TextEditingController message = TextEditingController();

  void report() async {
    if(message.text.isEmpty || message.text.length < 20) {
      notify.warn(message: "Report content cannot be empty nor less than 20 characters");
    } else {
      setState(() { isReporting = true; });
      var response = await _service.post(
          endpoint: "/account/report",
          body: {"content": message.text.trim(), "id": widget.isUser ? widget.id : null, "shop": widget.isUser ? null : widget.id}
      );
      setState(() { isReporting = false; });
      if(response.isSuccessful) {
        notify.success(message: response.message);
        widget.onSuccess?.call();
      } else {
        notify.error(message: response.message);
        widget.onError?.call();
      }
    }
  }

  @override
  void dispose() {
    message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
        safeArea: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: SText(
                      text: "Report ${widget.name}",
                      size: Sizing.font(22),
                      weight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                  ),
                ),
                const SizedBox(width: 15),
                Icon(
                  widget.isUser ? Icons.person_sharp : Icons.shopping_basket_rounded,
                  size: 60,
                  color: Theme.of(context).primaryColor
                )
              ],
            ),
            const SizedBox(height: 30),
            SText(
                text: "What are you reporting for?",
                size: Sizing.font(16),
                color: Theme.of(context).primaryColor
            ),
            Field(
              controller: message,
              needLabel: true,
              hintText: "Provide more context so that Serch can act effectively",
              labelColor: Theme.of(context).primaryColor,
              isBig: true,
              keyboard: TextInputType.text,
              inputAction: TextInputAction.done,
            ),
            const SizedBox(height: 15),
            LoadingButton(
              text: "Report",
              loading: isReporting,
              padding: EdgeInsets.all(Sizing.space(12)),
              borderRadius: 24,
              onClick: report,
              buttonColor: CommonColors.error,
              textColor: CommonColors.lightTheme,
              width: MediaQuery.of(context).size.width
            )
          ],
        )
    );
  }
}
