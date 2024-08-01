import 'dart:async';

import 'package:flutter/material.dart';
import 'package:user/library.dart';

class AskToVerifySheet extends StatefulWidget {
  final String emailAddress;
  final Function() onSuccess;
  const AskToVerifySheet({super.key, required this.emailAddress, required this.onSuccess});

  @override
  State<AskToVerifySheet> createState() => _AskToVerifySheetState();

  static void open({required String emailAddress, required Function() onSuccess}) => Navigate.bottomSheet(
    sheet: AskToVerifySheet(
      emailAddress: emailAddress,
      onSuccess: onSuccess,
    ),
    route: "/auth/guest/verify/ask",
    isScrollable: true
  );
}

class _AskToVerifySheetState extends State<AskToVerifySheet> {
  final ConnectService _connect = Connect(useToken: false);

  bool isSending = false;

  @override
  void initState() {
    super.initState();
    if(widget.emailAddress.isEmpty) {
      notify.error(message: "Unformatted email address");
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigate.all(GuestHomeLayout.route);
      });
    }
  }

  void send(BuildContext context) async {
    CommonUtility.unfocus(context);

    setState(() => isSending = true);
    var response = await _connect.post(endpoint: "/auth/guest/email/ask", body: {
      "email_address": widget.emailAddress
    });
    setState(() => isSending = false);
    if(response.isOk) {
      notify.success(message: response.message);
      Navigate.back();
      VerifyTokenSheet.open(
        emailAddress: widget.emailAddress,
        name: response.data,
        onSuccess: widget.onSuccess
      );
    } else {
      notify.error(message: response.message);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(Sizing.space(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LineHeader(
                  header: "Verify your email address?,",
                  footer: "This makes it easier to switch to user account later",
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 50),
              ]
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoadingButton(
                text: "Later",
                borderRadius: 24,
                textSize: Sizing.font(14),
                buttonColor: Theme.of(context).scaffoldBackgroundColor,
                textColor: Theme.of(context).primaryColor,
                onClick: () => Navigate.all(GuestHomeLayout.route),
              ),
              const SizedBox(width: 20),
              LoadingButton(
                text: "Verify",
                borderRadius: 24,
                textSize: Sizing.font(14),
                onClick: () => send(context),
                loading: isSending,
              )
            ],
          ),
        ],
      ),
    );
  }
}