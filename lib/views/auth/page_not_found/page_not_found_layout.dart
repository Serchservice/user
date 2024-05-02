import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class PageNotFoundLayout extends StatelessWidget {
  static const String route = "/page/error/404";
  const PageNotFoundLayout({super.key});

  @override
  Widget build(BuildContext context) {
    /// TODO:: Add button for guest account bottom sheet
    CommonApiService apiService = CommonApi();

    List<ButtonView> buttons = [
      ButtonView(
        icon: Icons.login_rounded,
        header: "Login to your Serch account",
        index: 0
      ),
      ButtonView(
        icon: Icons.account_circle_rounded,
        header: "Create new Serch account",
        index: 1
      ),
      ButtonView(
        icon: Icons.account_tree_rounded,
        header: "Continue with your Serch account",
        index: 2
      ),
    ];

    return ViewLayout(
      child: Padding(
        padding: EdgeInsets.all(Sizing.space(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              Media.logo,
              width: 100,
              color: Theme.of(context).primaryColor,
            ),
            LineHeader(
              header: "Page Not Found (404)",
              footer: "Oops. We couldn't find the page you looked for.",
              color: Theme.of(context).primaryColor,
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SText(
                      text: "There are multiple options to continue with, when this happens...",
                      size: Sizing.font(16),
                      color: Theme.of(context).primaryColor
                    ),
                    const SizedBox(height: 10),
                    ...buttons.map((value) {
                      if(value.index == 2 && Database.isLoggedIn) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: Sizing.space(8)),
                          child: LoadingButton(
                            text: value.header,
                            prefixIcon: value.icon,
                            prefixIconSize: Sizing.font(30),
                            borderRadius: 24,
                            textSize: Sizing.font(14),
                            width: MediaQuery.of(context).size.width,
                            onClick: () {
                              Loading.open(color: Get.theme.primaryColor, route: "/redirect_home");
                              apiService.validateSession(
                                onSuccess: (result) {
                                  Future.delayed(const Duration(seconds: 3), () {
                                    Navigate.all(HomeLayout.route);
                                  });
                                },
                                onError: (error) {
                                  Future.delayed(const Duration(seconds: 3), () {
                                    Navigate.all(EmailCheckerLayout.route);
                                  });
                                }
                              );
                            },
                          ),
                        );
                      }
                      return Padding(
                        padding: EdgeInsets.only(bottom: Sizing.space(8)),
                        child: LoadingButton(
                          text: value.header,
                          prefixIcon: value.icon,
                          prefixIconSize: Sizing.font(30),
                          borderRadius: 24,
                          textSize: Sizing.font(14),
                          width: MediaQuery.of(context).size.width,
                          onClick: () => Navigate.all(LocationCheckerLayout.route),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Image.asset(
                  Media.tagline,
                  width: 150,
                  color: Theme.of(context).primaryColor
                ),
              ),
            )
          ]
        ),
      )
    );
  }
}