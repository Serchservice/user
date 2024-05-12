import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ReferralLayout extends GetResponsiveView<ReferralController> {
  static const String route = "/centre/referral";
  ReferralLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Referral",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Sizing.space(16)),
              child: Obx(() {
                if(controller.state.isFetchingProgram.value) {
                  return LoadingShimmer(
                    content: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      decoration: BoxDecoration(
                        color: CommonColors.shimmerHigh,
                        borderRadius: BorderRadius.circular(16)
                      ),
                    )
                  );
                } else {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(Sizing.space(10)),
                    decoration: BoxDecoration(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SText.justify(
                          text: "With referrals, you get to increase the amount of credits you use in Serch."
                          " With credits, you spend less in the Serch platform, since you can pay with"
                          " them, and they can turn into real money discounts.",
                          color: Theme.of(context).primaryColor,
                          size: Sizing.font(9)
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LoadingButton(
                              text: "See my referral program",
                              buttonColor: Theme.of(context).scaffoldBackgroundColor,
                              textColor: Theme.of(context).primaryColor,
                              onClick: () => Navigate.bottomSheet(
                                sheet: ReferralProgramSheet(
                                  program: controller.state.program.value,
                                  showButton: false,
                                ),
                                safeArea: false,
                                isScrollable: true,
                                route: "/centre/referral/program/${controller.state.program.value.data.referralCode}"
                              ),
                            ),
                            IconButton(
                              tooltip: "Share referral",
                              onPressed: () => ShareSheet.open(
                                link: controller.state.program.value.data.referLink,
                                code: controller.state.program.value.data.referralCode,
                                caption: controller.state.program.value.data.referLink
                              ),
                              icon: Icon(
                                Icons.copy,
                                size: Sizing.space(16),
                                color: Theme.of(context).primaryColor
                              )
                            )
                          ],
                        )
                      ],
                    )
                  );
                }
              }),
            ),
            Obx(() {
              if(controller.state.isFetching.value) {
                return Padding(
                  padding: EdgeInsets.all(Sizing.space(16)),
                  child: LoadingShimmer(
                    content: ListView.builder(
                      itemCount: 6,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(bottom: Sizing.space(10)),
                          height: 70,
                          decoration: BoxDecoration(
                            color: CommonColors.shimmerHigh,
                            borderRadius: BorderRadius.circular(16)
                          ),
                        );
                      }
                    )
                  )
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(controller.state.referrals.isEmpty) ...[
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 150),
                            Opacity(
                              opacity: 0.2,
                              child: Icon(
                                Icons.account_tree_rounded,
                                color: Theme.of(context).primaryColor,
                                size: 100
                              ),
                            ),
                            const SizedBox(height: 10),
                            SText.center(
                              text: "You do not have any referrals",
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      )
                    ],
                    if(controller.state.referrals.isNotEmpty) ...[
                      ...controller.state.referrals.map((referral) => Column(
                        children: [
                          Divider(color: Theme.of(context).primaryColor),
                          Padding(
                            padding: EdgeInsets.all(Sizing.space(10)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Avatar.medium(avatar: referral.avatar),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SText.center(
                                        text: referral.name,
                                        size: Sizing.space(14),
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      SText.center(
                                        text: referral.data?.label ?? "",
                                        size: Sizing.space(9),
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      SText.center(
                                        text: "${referral.data?.info}",
                                        size: Sizing.space(9),
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ],
                                  )
                                ),
                                const SizedBox(width: 10),
                                SText.center(
                                  text: referral.role,
                                  size: Sizing.space(12),
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ))
                    ]
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}