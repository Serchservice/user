import 'package:flutter/material.dart';
import 'package:user/library.dart';

class AuthWithMultiFactor extends StatefulWidget {
  final bool isLogin;
  const AuthWithMultiFactor({super.key, required this.isLogin});

  static void open() => Navigate.bottomSheet(
    sheet: const AuthWithMultiFactor(isLogin: false),
    route: "/centre/privacy-and-security/multi-factor/verify",
    background: Colors.transparent,
    isScrollable: true
  );

  static void login() => Navigate.bottomSheet(
    sheet: const AuthWithMultiFactor(isLogin: true),
    route: "/auth/login/mfa",
    background: Colors.transparent,
    isScrollable: true
  );

  @override
  State<AuthWithMultiFactor> createState() => _AuthWithMultiFactorState();
}

class _AuthWithMultiFactorState extends State<AuthWithMultiFactor> {
  final ConnectService _connect = Connect();
  final TextEditingController authController = TextEditingController();
  final FocusNode authFocusNode = FocusNode();

  bool loading = false;
  String token = "";
  bool isRecovery = false;

  List<String> buttons = ["Recovery Code", "Code"];

  void verify({String? code}) async {
    if(code != null) {
      setState(() => token = code);
    }

    if(token.isEmpty || token.length < 6) {
      notify.warn(message: "Incorrect token");
      return;
    } else {
      setState(() {
        loading = true;
      });
      var response = await _connect.post(
        endpoint: isRecovery ? "/auth/mfa/recovery/code/verify" : "/auth/mfa/verify/code",
        body: {"code": token, "device": Database.device.toJson()}
      );
      setState(() {
        loading = false;
      });
      if(response.isOk) {
        AuthResponse auth = AuthResponse.fromJson(response.data);
        Database.saveAuth(auth);
        if(widget.isLogin) {
          Navigate.all(HomeLayout.route);
        } else {
          Navigate.back();
        }
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
                    text: widget.isLogin ? "Login with Two-Factor" : "Confirm Two-Factor Removal",
                    color: Theme.of(context).primaryColor,
                    size: Sizing.font(24),
                    weight: FontWeight.bold,
                  ),
                ),
                if(!widget.isLogin)...[
                  GoBack(
                    color: Theme.of(context).primaryColor,
                    icon: Icons.close
                  )
                ]
              ],
            ),
            const Divider(),
            const SizedBox(height: 15),
            SText(
              text: widget.isLogin ? "Confirm your identity with two-factor" : "Disable two-factor authentication",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(16),
              weight: FontWeight.bold,
            ),
            SText(
              text: "You can either use recovery code or Google Authenticator Code.",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(12),
              weight: FontWeight.bold,
            ),
            const SizedBox(height: 15),
            OtpField(
              controller: authController,
              focusNode: authFocusNode,
              isBox: false,
              onCompleted: (code) => verify(code: code),
              onChanged: (code) => setState(() => token = code)
            ),
            const SizedBox(height: 20),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: buttons.length,
                crossAxisSpacing: 8,
                mainAxisExtent: 30
              ),
              shrinkWrap: true,
              itemCount: buttons.length,
              itemBuilder: (context, index) {
                return ButtonSelector(
                  text: buttons[index],
                  selected: index == 0 ? isRecovery : !isRecovery,
                  unSelectedBgColor: Theme.of(context).scaffoldBackgroundColor,
                  onTap: (value) {
                    if(index == 0) {
                      setState(() {
                        isRecovery = true;
                      });
                    } else {
                      setState(() {
                        isRecovery = false;
                      });
                    }
                  },
                  index: index
                );
              },
            ),
            const SizedBox(height: 70),
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