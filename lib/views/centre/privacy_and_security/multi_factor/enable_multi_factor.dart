import 'package:flutter/material.dart';
import 'package:user/library.dart';

class EnableMultiFactor extends StatefulWidget {
  final EnableMfa mfa;
  final Function() onSuccess;
  const EnableMultiFactor({super.key, required this.mfa, required this.onSuccess});

  static void open({required EnableMfa mfa, required Function() onSuccess}) => Navigate.bottomSheet(
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
  final Connect _connect = Connect();
  List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());
  bool loading = false;

  void verify() async {
    CommonUtility.unfocus(context);

    String token = controllers.map((controller) => controller.text).join('');
    if(token.isEmpty || token.length < 6) {
      SnackBars.top(message: "Incorrect token", type: Snackbar.error);
      return;
    } else {
      setState(() {
        loading = true;
      });
      try {
        var res = await _connect.post(
          endpoint: "/auth/mfa/verify/code",
          body: {
            "code": token,
            "device": Database.device.toJson()
          }
        );
        setState(() {
          loading = false;
        });
        ApiResponse response = ApiResponse.fromJson(res.data);
        if(response.isOk) {
          AuthResponse auth = AuthResponse.fromJson(response.data);
          Database.saveAuth(auth);
          Navigate.back();
          widget.onSuccess.call();
        } else {
          SnackBars.top(message: response.message, type: Snackbar.error);
        }
      } on Exception catch (e) {
        setState(() {
          loading = false;
        });
        Connect.showError(e);
      }
    }
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
                      verify();
                    } else if(value.length == 1){
                      FocusScope.of(context).nextFocus();
                    }
                  },
                );
              },
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