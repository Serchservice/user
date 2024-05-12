import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class CentreLayout extends GetResponsiveView<HomeController> {
  CentreLayout({super.key});

  @override
  Widget build(BuildContext context) {
    List<ButtonView> quickActions = [
      ButtonView(
        icon: Icons.chat_bubble_rounded,
        header: "Speak with Serch",
        path: SpeakWithSerchLayout.route
      ),
      ButtonView(
        icon: Icons.link_rounded,
        header: "My Links",
        path: SharedLinksLayout.route
      ),
      ButtonView(
        icon: Icons.help_outline_sharp,
        header: "Help",
        path: HelpLayout.route
      ),
    ];
    List<ButtonView> tabs = [
      ButtonView(
        icon: Icons.account_circle_rounded,
        header: "Account",
        body: "Manage your profile and account details",
        path: AccountLayout.route
      ),
      ButtonView(
        icon: Icons.wallet_rounded,
        header: "Wallet",
        body: "Manage your wallet transactions and funds",
        path: WalletLayout.route
      ),
      ButtonView(
        icon: Icons.bookmarks_rounded,
        header: "Bookmarks",
        body: "Manage the providers you've saved for later",
        path: BookmarkLayout.route
      ),
      ButtonView(
        icon: Icons.star_rate_rounded,
        header: "Rating",
        body: "Understand why your rating is low or high",
        path: RatingLayout.route
      ),
      ButtonView(
        icon: Icons.account_tree_rounded,
        header: "Referral",
        body: "See what your referral program is building",
        path: ReferralLayout.route
      ),
      ButtonView(
        icon: Icons.security_rounded,
        header: "Privacy and Security",
        body: "Protect your account in the best way possible",
        path: PrivacyAndSecurityLayout.route
      ),
      ButtonView(
        icon: Icons.settings_suggest_rounded,
        header: "Preferences",
        body: "Personalize your app settings the way that suits you",
        path: PreferenceLayout.route
      ),
      ButtonView(
        icon: Icons.apps_rounded,
        header: "App Information",
        body: "Rate the Serch platform and see platform updates",
        path: AppInformationLayout.route,
        index: 1
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => CentreHeader(
          name: controller.state.name.value,
          rating: controller.state.rating.value,
          avatar: controller.state.avatar.value
        )),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: Sizing.space(16),
                    right: Sizing.space(16),
                    top: Sizing.space(16),
                    bottom: Sizing.space(8)
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: quickActions.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return CentreQuickAction(action: quickActions[index]);
                    }
                  ),
                ),
                const Divider(),
                Obx(() {
                  bool showNotification = controller.state.hasSerchMessage.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: tabs.map((tab) => CentreNavigator(
                      tab: tab,
                      needNotification: tab.index == 1 && showNotification,
                      onTap: () {
                        if(tab.path.isNotEmpty) {
                          Navigate.to(tab.path);
                        }
                      },
                    )).toList(),
                  );
                }),
                const SizedBox(height: 10),
              ],
            )
          ),
        )
      ],
    );
  }
}