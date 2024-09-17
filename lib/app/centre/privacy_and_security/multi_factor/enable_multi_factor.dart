import 'package:flutter/material.dart';
import 'package:user/library.dart';

class EnableMultiFactor extends StatelessWidget {
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
              text: "Scan this QR Code with your authenticator app or copy the code to your authenticator app.",
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
                    image: AssetUtility.image(mfa.qrCode),
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SText.center(
                          text: mfa.secret,
                          color: Theme.of(context).primaryColor,
                          size: Sizing.font(16),
                          weight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () => CommonUtility.copy(mfa.secret),
                        icon: Icon(Icons.copy_rounded, color: Theme.of(context).primaryColor)
                      )
                    ],
                  ),
                ],
              )
            ),
            const SizedBox(height: 15),
            LoadingButton(
              text: "Verify",
              borderRadius: 24,
              width: MediaQuery.of(context).size.width,
              textSize: Sizing.font(14),
              onClick: () async {
                dynamic result = await Navigate.off(MfaAuthLayout.enableRoute);
                if(result != null && result is bool) {
                  onSuccess.call();
                }
              },
            )
          ]
        ),
      )
    );
  }
}