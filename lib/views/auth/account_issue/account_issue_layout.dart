import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class AccountIssueLayout extends GetResponsiveView<AccountIssueController> {
  static String route = "/auth/account/issues";

  AccountIssueLayout({super.key});

  @override
  Widget build(BuildContext context) {
    List<ButtonView> buttons = [
      ButtonView(
        header: "Serch Community Guidelines",
        body: "Understand the community you thrive in.",
        icon: Icons.rule_rounded,
        path: Links.web("/")
      ),
      ButtonView(
        header: "Serch Non-Discrimination Policy",
        body: "Read our policy to avoid issues.",
        icon: Icons.polymer_sharp,
        path: Links.web("/")
      ),
    ];

    return ViewLayout(
      child: Column(
        children: [
          Image.asset(
            Media.logo,
            height: 150,
            color: Theme.of(context).primaryColor
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(Sizing.space(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(Sizing.space(12)),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(Sizing.space(12)),
                    ),
                    child: Obx(() => SText(
                      text: controller.state.message.value,
                      size: Sizing.font(14),
                      color: Theme.of(context).scaffoldBackgroundColor
                    ))
                  ),
                  const SizedBox(height: 30),
                  SText(
                    text: "Read our guidelines to see why this could have happened:",
                    color: Theme.of(context).primaryColor
                  ),
                  const SizedBox(height: 30),
                  ...buttons.map((button) => Padding(
                    padding: EdgeInsets.only(bottom: Sizing.space(10)),
                    child: NavigatorButton(
                      header: button.header,
                      backgroundColor: Theme.of(context).splashColor,
                      detail: button.body,
                      prefixIcon: button.icon,
                      onPressed: () => RouteNavigator.openWeb(
                        header: button.header,
                        url: button.path
                      ),
                    )
                  )).toList(),
                  const SizedBox(height: 30),
                  LoadingButton(
                    text: "Send us a message to recover your account",
                    width: MediaQuery.of(context).size.width,
                    buttonColor: Theme.of(context).splashColor,
                    textColor: Theme.of(context).primaryColorLight,
                    prefixIcon: Icons.send_time_extension_rounded,
                    prefixIconSize: Sizing.font(30),
                    onClick: () => RouteNavigator.mail("team@serchservice.com"),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: Sizing.space(20)),
            child: Center(
              child: Image.asset(
                Media.tagline,
                width: 150,
                color: Theme.of(context).primaryColor
              ),
            ),
          )
        ]
      )
    );
  }
}