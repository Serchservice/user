import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountDelete extends StatefulWidget {
  const AccountDelete({super.key});

  @override
  State<AccountDelete> createState() => _AccountDeleteState();

  static void open() => Navigate.bottomSheet(
    sheet: const AccountDelete(),
    route: "/centre/account/delete",
    background: Colors.transparent,
    isScrollable: true
  );
}

class _AccountDeleteState extends State<AccountDelete> {
  final ConnectService _connect = Connect();
  bool loading = false;

  void deleteAccount() async {
    setState(() {
      loading = true;
    });
    var response = await _connect.get(endpoint: "/account/delete");
    setState(() {
      loading = false;
    });
    if(response.isOk) {
      await Database.clear;
      Get.changeThemeMode(ThemeMode.light);
      EmailCheckerLayout.all();
    } else {
      Navigate.back();
      notify.error(message: response.message);
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
                    text: "Delete account",
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
              text: "Are you sure that you want to delete your account?",
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
                text: "Account deletion takes 30 days. If you login within that period, this action will be cancelled.",
                color: Theme.of(context).primaryColor,
                size: Sizing.font(12),
                weight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            LoadingButton(
              text: "Confirm",
              borderRadius: 24,
              width: MediaQuery.sizeOf(context).width,
              textSize: Sizing.font(14),
              onClick: () => deleteAccount(),
              loading: loading,
            )
          ]
        ),
      )
    );
  }
}