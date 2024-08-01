import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class PageNotFoundLayout extends StatelessWidget {
  static const String route = "/page/error/404";
  const PageNotFoundLayout({super.key});

  @override
  Widget build(BuildContext context) {
    List<ButtonView> buttons = [
      if(!Database.isLoggedIn)...[
        ButtonView(
            icon: Icons.account_circle_rounded,
            header: "Create a Serch account",
            index: 0
        ),
        ButtonView(
            icon: Icons.account_circle_rounded,
            header: "Login to your Serch account",
            index: 0
        ),
      ],
      if(Database.accounts.isNotEmpty) ...[
        ButtonView(
            icon: Icons.account_tree_rounded,
            header: "Continue with your Serch account",
            index: 2
        )
      ]
    ];

    return MainLayout(
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
                      return Padding(
                        padding: EdgeInsets.only(bottom: Sizing.space(8)),
                        child: LoadingButton(
                          text: value.header,
                          prefixIcon: value.icon,
                          prefixIconSize: Sizing.font(30),
                          borderRadius: 16,
                          textSize: Sizing.font(14),
                          width: MediaQuery.of(context).size.width,
                          buttonColor: Theme.of(context).appBarTheme.backgroundColor,
                          textColor: Theme.of(context).primaryColor,
                          onClick: () {
                            if(value.index == 2) {
                              AccountPicker.open(
                                shouldNavigate: true,
                                onUserSuccess: () {
                                  if(HomeController.data.initialized) {
                                    Future.delayed(const Duration(seconds: 3), () {
                                      Navigate.till((route) => Get.currentRoute == HomeLayout.route);
                                    });
                                  } else {
                                    Future.delayed(const Duration(seconds: 3), () {
                                      Navigate.all(HomeLayout.route);
                                    });
                                  }
                                },
                                onUserError: (guestOnTrip) {
                                  if(guestOnTrip) {
                                    notify.info(message: "You have an account that is on trip. You need to locate that account");
                                    return;
                                  }
                                  Navigate.all(EmailCheckerLayout.route);
                                },
                                onGuestError: (guestOnTrip) {
                                  if(guestOnTrip) {
                                    notify.info(message: "You have a guest account that is on trip. You need to locate that account");
                                  }
                                },
                                onGuestSuccess: (guest) => Navigate.all(GuestHomeLayout.route)
                              );
                            } else {
                              Navigate.all(LocationCheckerLayout.route);
                            }
                          },
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