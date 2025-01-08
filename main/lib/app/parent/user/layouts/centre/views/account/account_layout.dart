import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountLayout extends GetResponsiveView<AccountController> {
  static const String route = "/centre/account";
  AccountLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Account",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
        actions: [
          InfoButton(onPressed: AccountNotifier.open)
        ],
      ),
      child: Obx(() {
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
                    width: MediaQuery.sizeOf(context).width,
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
                          width: MediaQuery.sizeOf(context).width,
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
                        onPressed: () => Navigate.to(AccountUpdateLayout.route),
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
                ...controller.profile().map((profile) => CentreNavigator(tab: profile)),
                const SizedBox(height: 5),
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
                ...controller.buttons.map((button) => CentreNavigator(
                  tab: button,
                  onTap: () => Navigate.to(button.path),
                )),
                Divider(color: Theme.of(context).primaryColor),
                const SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(Sizing.space(9)),
                  decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor
                  ),
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SText.center(
                        text: 'Account Summary',
                        color: Theme.of(context).primaryColor,
                        size: Sizing.font(16),
                        weight: FontWeight.bold
                      ),
                      const SizedBox(height: 5),
                      SummaryItem(title: "Last Signed In", value: controller.state.profile.value.more.lastSignedIn),
                      SummaryItem(title: "Number of Ratings", value: "${controller.state.profile.value.more.numberOfRating}"),
                      SummaryItem(title: "Total Service Trips", value: "${controller.state.profile.value.more.totalServiceTrips}"),
                      SummaryItem(title: "Number of Shops", value: "${controller.state.profile.value.more.numberOfShops}"),
                      SummaryItem(title: "Total Shared Links", value: "${controller.state.profile.value.more.totalShared}"),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Divider(color: Theme.of(context).primaryColor),
                const SizedBox(height: 15),
                ...controller.securities.map((security) => CentreNavigator(
                  tab: security,
                  color: CommonColors.error,
                  onTap: () => controller.openSecurity(security),
                ))
              ]
            )
          );
        }
      }),
    );
  }
}
