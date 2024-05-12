import 'package:flutter/material.dart';
import 'package:user/library.dart';

class DisableMultiFactor extends StatefulWidget {
  final Function() onSuccess;
  const DisableMultiFactor({super.key, required this.onSuccess});

  @override
  State<DisableMultiFactor> createState() => _DisableMultiFactorState();

  static void open({required Function() onSuccess}) => Navigate.bottomSheet(
    sheet: DisableMultiFactor(onSuccess: onSuccess),
    route: "/centre/privacy-and-security/multi-factor/disable",
    background: Colors.transparent,
    isScrollable: true
  );
}

class _DisableMultiFactorState extends State<DisableMultiFactor> {
  final Connect _connect = Connect();
  bool loading = false;

  void verify() async {
    setState(() {
      loading = true;
    });
    try {
      var res = await _connect.delete(endpoint: "/auth/mfa/disable", body: Database.device.toJson());
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
            SText.center(
              text: "Are you sure that you want to disable Two-Factor Authentication?",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(16),
              weight: FontWeight.bold,
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(20)
              ),
              child: SText(
                text: "This action will most certainly reduce the security level of your account.",
                color: Theme.of(context).primaryColor,
                size: Sizing.font(12),
                weight: FontWeight.bold,
              ),
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