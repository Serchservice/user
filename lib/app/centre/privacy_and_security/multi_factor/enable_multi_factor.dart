import 'package:flutter/material.dart';
import 'package:user/library.dart';

class EnableMultiFactor extends StatefulWidget {
  final EnableMfaResponse mfa;
  final Function() onSuccess;
  const EnableMultiFactor({super.key, required this.mfa, required this.onSuccess});

  static void open({required EnableMfaResponse mfa, required Function() onSuccess}) => Navigate.bottomSheet(
    sheet: EnableMultiFactor(
      mfa: mfa,
      onSuccess: onSuccess,
    ),
    route: "/centre/privacy-and-security/multi-factor/enable",
    background: Colors.transparent,
    isScrollable: true
  );

  @override
  State<EnableMultiFactor> createState() => _EnableMultiFactorState();
}

class _EnableMultiFactorState extends State<EnableMultiFactor> {
  final ConnectService _connect = Connect();
  final TextEditingController authController = TextEditingController();
  final FocusNode authFocusNode = FocusNode();

  bool loading = false;
  String token = "";

  void verify({String? code}) async {
    if(code != null) {
      setState(() => token = code);
    }

    if(token.isEmpty || token.length < 6) {
      notify.error(message: "Incorrect token");
      return;
    } else {
      setState(() {
        loading = true;
      });
      var response = await _connect.post(
        endpoint: "/auth/mfa/verify/code",
        body: {"code": token, "device": Database.device.toJson()}
      );
      setState(() {
        loading = false;
      });
      if(response.isOk) {
        AuthResponse auth = AuthResponse.fromJson(response.data);
        Database.saveAuth(auth);
        Navigate.back();
        widget.onSuccess.call();
      } else {
        notify.error(message: response.message);
      }
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(Sizing.space(2)),
                width: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(16)
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: SText(
                    text: "Two-Factor Authentication",
                    color: Theme.of(context).primaryColor,
                    size: Sizing.font(24),
                    weight: FontWeight.bold,
                  ),
                ),
                GoBack(
                  color: Theme.of(context).primaryColor,
                  icon: Icons.close
                )
              ],
            ),
            const Divider(),
            const SizedBox(height: 15),
            SText(
              text: "Set up two-factor authentication",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(16),
              weight: FontWeight.bold,
            ),
            SText(
              text: "Scan this QR Code with your Google Authenticator app or copy the code to your"
              " Google Authenticator app.",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(12),
              weight: FontWeight.bold,
            ),
            const SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(Sizing.space(8)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Theme.of(context).primaryColor, width: 3)
              ),
              child: Column(
                children: [
                  Image(
                    image: AssetUtility.image(widget.mfa.qrCode),
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SText.center(
                          text: widget.mfa.secret,
                          color: Theme.of(context).primaryColor,
                          size: Sizing.font(16),
                          weight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () => CommonUtility.copy(widget.mfa.secret),
                        icon: Icon(
                          Icons.copy_rounded,
                          color: Theme.of(context).primaryColor
                        )
                      )
                    ],
                  ),
                ],
              )
            ),
            const SizedBox(height: 15),
            SText(
              text: "Enter Google Authenticator Verification Code",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(14),
              weight: FontWeight.bold,
            ),
            const SizedBox(height: 10),
            OtpField(
              controller: authController,
              focusNode: authFocusNode,
              onCompleted: (code) => verify(code: code),
              onChanged: (code) => setState(() => token = code)
            ),
            const SizedBox(height: 50),
            LoadingButton(
              text: "Confirm",
              borderRadius: 24,
              width: MediaQuery.of(context).size.width,
              textSize: Sizing.font(14),
              onClick: () => verify(),
              loading: loading,
            )
          ]
        ),
      )
    );
  }
}