import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class AccountLayout extends GetResponsiveView<AccountController> {
  static const String route = "/centre/account";
  AccountLayout({super.key});

  @override
  Widget build(BuildContext context) {
    List<ButtonView> buttons = [
      ButtonView(
        index: 2,
        icon: Icons.link_rounded,
        header: "Shared Links",
        body: "Manage your provideShared links. See how it's usage",
        path: SharedLinksLayout.route
      ),
    ];

    List<ButtonView> securities = [
      ButtonView(
        index: 0,
        icon: Icons.logout_rounded,
        header: "Sign out",
      ),
      ButtonView(
        index: 1,
        icon: Icons.delete_rounded,
        header: "Delete my account",
      ),
    ];
    return ViewLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Account",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: Obx(() {
        List<ButtonView> profile = [
          ButtonView(
            icon: Icons.person_outline_rounded,
            header: "Legal FirstName",
            body: controller.state.profile.value.firstName,
          ),
          ButtonView(
            icon: Icons.person_3_outlined,
            header: "Legal LastName",
            body: controller.state.profile.value.lastName,
          ),
          ButtonView(
            icon: Icons.phone_outlined,
            header: "Phone Number",
            body: controller.state.phone.value,
          ),
          ButtonView(
            icon: Icons.people_outline_outlined,
            header: "Gender",
            body: controller.state.profile.value.gender,
          ),
          ButtonView(
            icon: Icons.email_outlined,
            header: "Email Address",
            body: controller.state.profile.value.emailAddress,
          ),
        ];
        if(controller.state.isFetching.value) {
          return LoadingShimmer(
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 20
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(100),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: CommonColors.shimmerHigh
                        )
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(bottom: Sizing.space(20)),
                    height: 40,
                    decoration: BoxDecoration(
                      color: CommonColors.shimmerHigh,
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 6,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(bottom: Sizing.space(10)),
                          height: 80,
                          decoration: BoxDecoration(
                            color: CommonColors.shimmerHigh,
                            borderRadius: BorderRadius.circular(6)
                          ),
                        );
                      }
                    ),
                  )
                ],
              ),
            )
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 20
                  ),
                  child: Center(
                    child: Avatar(
                      radius: 90,
                      avatar: controller.state.profile.value.avatar,
                    ),
                  ),
                ),
                if(controller.state.showAccount.value) ...[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(Sizing.space(12)),
                    margin: EdgeInsets.symmetric(
                      vertical: Sizing.space(16),
                      horizontal: 8.0
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).splashColor,
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SText(
                            text: "Note that the portal for profile update opens once every year."
                            " As we are dedicated to making our platforms easy to use, we also value"
                            " honesty in data, so always provide your correct data.\n\n"
                            " We reserve the right to suspend your account if your data is not legally correct.",
                            color: Theme.of(context).primaryColor,
                            size: Sizing.font(9)
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: "Tap here to edit",
                          onPressed: () => controller.stopShowingAccount(),
                          icon: Icon(
                            Icons.close,
                            color: Theme.of(context).primaryColor,
                          )
                        )
                      ],
                    )
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: SText(
                          text: "Profile",
                          color: Theme.of(context).primaryColor,
                          size: Sizing.font(16),
                          weight: FontWeight.bold
                        ),
                      ),
                      TextButton(
                        onPressed: () => EditProfile.open(
                          profile: controller.state.profile.value,
                          controller: controller
                        ),
                        child: SText(
                          text: "Tap here to edit",
                          color: Theme.of(context).primaryColor,
                          size: Sizing.font(14),
                          weight: FontWeight.bold
                        )
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                ...profile.map((profile) => CentreNavigator(tab: profile)),
                Divider(color: Theme.of(context).primaryColor),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SText(
                    text: "Utilities",
                    color: Theme.of(context).primaryColor,
                    size: Sizing.font(16),
                    weight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 5),
                ...buttons.map((button) => CentreNavigator(
                  tab: button,
                  onTap: () {
                    if(button.index == 4) {
                      // Open business profile sheet
                    } else {
                      Navigate.to(button.path);
                    }
                  },
                )),
                Divider(color: Theme.of(context).primaryColor),
                const SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(Sizing.space(9)),
                  decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SText.center(
                        text: 'Account Summary',
                        color: Theme.of(context).primaryColor,
                        size: Sizing.font(16),
                        weight: FontWeight.bold
                      ),
                      const SizedBox(height: 10),
                      SummaryBox(title: "Last Signed In", value: controller.state.profile.value.more.lastSignedIn),
                      const SizedBox(height: 5),
                      SummaryBox(title: "Number of Ratings", value: "${controller.state.profile.value.more.numberOfRating}"),
                      const SizedBox(height: 5),
                      SummaryBox(title: "Total Service Trips", value: "${controller.state.profile.value.more.totalServiceTrips}"),
                      const SizedBox(height: 5),
                      SummaryBox(title: "Number of Shops", value: "${controller.state.profile.value.more.numberOfShops}"),
                      const SizedBox(height: 5),
                      SummaryBox(title: "Total Shared Links", value: "${controller.state.profile.value.more.totalShared}"),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Divider(color: Theme.of(context).primaryColor),
                const SizedBox(height: 15),
                ...securities.map((security) => CentreNavigator(
                  tab: security,
                  color: CommonColors.error,
                  onTap: () {
                    if(security.index == 0) {
                      Signout.open();
                    } else {
                      DeleteAccount.open();
                    }
                  },
                ))
              ]
            )
          );
        }
      }),
    );
  }
}
