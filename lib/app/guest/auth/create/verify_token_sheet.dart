import 'dart:async';

import 'package:flutter/material.dart';
import 'package:user/library.dart';

class VerifyTokenSheet extends StatefulWidget {
  final String emailAddress;
  final String name;
  final Function() onSuccess;
  const VerifyTokenSheet({
    super.key,
    required this.emailAddress,
    required this.name,
    required this.onSuccess
  });

  @override
  State<VerifyTokenSheet> createState() => _VerifyTokenSheetState();

  static void open({
    required String emailAddress,
    required String name,
    required Function() onSuccess
  }) => Navigate.bottomSheet(
    sheet: VerifyTokenSheet(
      emailAddress: emailAddress,
      name: name,
      onSuccess: onSuccess,
    ),
    route: "/auth/guest/verify",
    isScrollable: true
  );
}

class _VerifyTokenSheetState extends State<VerifyTokenSheet> {
  final ConnectService _connect = Connect(useToken: false);

  Timer? _timer;
  int timeout = 59;
  bool isCounting = true;
  bool isResending = false;
  bool isVerifying = false;

  final TextEditingController authController = TextEditingController();
  final FocusNode authFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if(widget.emailAddress.isNotEmpty) {
      startTimer();
    } else {
      notify.error(message: "Unformatted email address");
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigate.all(GuestHomeLayout.route);
      });
    }
  }

  void startTimer() {
    if(timeout != 59) {
      _timer?.cancel();
      setState(() => timeout = 59);

      updateTimer();
    } else {
      updateTimer();
    }
  }

  void updateTimer() {
    Timer.periodic(const Duration(seconds: 1), (newTimer) {
      setState(() => _timer = newTimer);

      if(timeout == 0) {
        newTimer.cancel();
        setState(() => isCounting = false);
      } else {
        setState(() {
          timeout--;
          isCounting = true;
        });
      }
    });
  }

  void resend() async {
    setState(() => isResending = true);
    var response = await _connect.post(endpoint: "/auth/guest/email/ask", body: {
      "email_address": widget.emailAddress
    });
    setState(() => isResending = false);
    if(response.isOk) {
      notify.success(message: response.message);
      startTimer();
      return;
    } else {
      notify.error(message: response.message);
      return;
    }
  }

  String token = "";

  void verify({String? code}) async {
    if(code != null) {
      setState(() => token = code);
    }

    if(token.isEmpty || token.length < 6) {
      notify.error(message: "Incorrect token");
      return;
    }
    setState(() => isVerifying = true);
    var response = await _connect.post(
        endpoint: "/auth/guest/email/verify",
        body: {
          "email_address": widget.emailAddress,
          "token": token,
        }
    );
    setState(() => isVerifying = false);
    if(response.isOk) {
      widget.onSuccess.call();
    } else {
      notify.error(message: response.message);
      return;
    }
  }

  @override
  void dispose() {
    authController.dispose();
    authFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          LineHeader(
            header: "Hi ${widget.name},",
            footer: "Check your ${widget.emailAddress} inbox for verification token",
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 50),
          OtpField(
            controller: authController,
            focusNode: authFocusNode,
            onCompleted: (code) => verify(code: code),
            onChanged: (code) => setState(() => token = code)
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if(isCounting) ...[
                SText(
                  text: "Request another in: $timeout seconds",
                  size: Sizing.font(14),
                  color: Theme.of(context).primaryColor,
                )
              ],
              if(!isCounting) ...[
                LoadingButton(
                  text: "Resend OTP",
                  textSize: Sizing.font(14),
                  buttonColor: isCounting
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Theme.of(context).bottomAppBarTheme.color,
                  textColor: Theme.of(context).primaryColor,
                  onClick: () => resend(),
                  loading: isResending,
                )
              ]
            ],
          ),
          const SizedBox(height: 50),
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
                text: "Confirm",
                borderRadius: 24,
                textSize: Sizing.font(14),
                onClick: () => verify(),
                loading: isVerifying,
              )
            ],
          ),
        ],
      ),
    );
  }
}