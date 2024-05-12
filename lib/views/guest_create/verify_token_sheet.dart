import 'dart:async';

import 'package:flutter/material.dart';
import 'package:user/library.dart';

class VerifyTokenSheet extends StatefulWidget {
  final String emailAddress;
  final String name;
  const VerifyTokenSheet({super.key, required this.emailAddress, required this.name});

  @override
  State<VerifyTokenSheet> createState() => _VerifyTokenSheetState();

  static void open({required String emailAddress, required String name}) => Navigate.bottomSheet(
    sheet: VerifyTokenSheet(emailAddress: emailAddress, name: name),
    route: "/auth/guest/verify",
    isScrollable: true
  );
}

class _VerifyTokenSheetState extends State<VerifyTokenSheet> {
  final Connect _connect = Connect(useToken: false);

  Timer? _timer;
  int timeout = 59;
  bool isCounting = true;
  bool isResending = false;
  bool isVerifying = false;
  String otp = "";
  List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    if(widget.emailAddress.isNotEmpty) {
      startTimer();
    } else {
      SnackBars.top(message: "Unformatted email address", type: Snackbar.error);
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

  void resend(BuildContext context) async {
    CommonUtility.unfocus(context);

    setState(() => isResending = true);
    try {
      var response = await _connect.post(endpoint: "/auth/guest/email/ask", body: {
        "email_address": widget.emailAddress
      });
      setState(() => isResending = false);
      var apiResponse = ApiResponse.fromJson(response.data);
      if(apiResponse.isOk) {
        SnackBars.top(message: apiResponse.message, type: Snackbar.success);
        startTimer();
        return;
      } else {
        SnackBars.top(message: apiResponse.message, type: Snackbar.error);
        return;
      }
    } on Exception catch (e) {
      setState(() => isResending = false);
      Connect.showError(e);
    }
  }

  void verify(BuildContext context) async {
    CommonUtility.unfocus(context);

    setState(() => otp = controllers.map((controller) => controller.text).join(''));
    if(otp.isEmpty || otp.length < 6) {
      SnackBars.top(message: "Incorrect token", type: Snackbar.error);
      return;
    }
    setState(() => isVerifying = true);
    try {
      var response = await _connect.post(
        endpoint: "/auth/guest/email/verify",
        body: {
          "email_address": widget.emailAddress,
          "token": otp,
        }
      );
      setState(() => isVerifying = false);
      var apiResponse = ApiResponse.fromJson(response.data);
      if(apiResponse.isOk) {
        Navigate.all(GuestHomeLayout.route);
      } else {
        SnackBars.top(message: apiResponse.message, type: Snackbar.error);
        return;
      }
    } on Exception catch (e) {
      setState(() => isVerifying = false);
      Connect.showError(e);
    }
  }

  @override
  void dispose() {
    for (var element in controllers) {
      element.dispose();
    }
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
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 8,
              mainAxisExtent: 50
            ),
            shrinkWrap: true,
            itemCount: controllers.length,
            itemBuilder: (context, index) {
              return Field(
                isOTP: true,
                textSize: Sizing.font(20),
                keyboard: TextInputType.number,
                controller: controllers[index],
                onChanged: (value) {
                  if(controllers[index] == controllers.last && value.length == 1) {
                    FocusScope.of(context).unfocus();
                    verify(context);
                  } else if(value.length == 1){
                    FocusScope.of(context).nextFocus();
                  }
                },
              );
            },
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
                  onClick: () => resend(context),
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
                onClick: () => verify(context),
                loading: isVerifying,
              )
            ],
          ),
        ],
      ),
    );
  }
}