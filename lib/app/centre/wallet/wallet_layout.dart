import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class WalletLayout extends GetResponsiveView<WalletController> {
  static const String route = "/centre/wallet";
  WalletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    List<ButtonView> tabs = [
      ButtonView(header: "Fund", icon: Icons.add_rounded),
      ButtonView(header: "Withdraw", icon: Icons.send_rounded),
      ButtonView(header: "View info", icon: Icons.wallet_rounded),
      ButtonView(header: "Transactions", icon: Icons.history_rounded),
    ];

    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Wallet",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              if(controller.state.isFetchingWallet.value) {
                return LoadingShimmer(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(Sizing.space(15)),
                    padding: const EdgeInsets.all(12.0),
                    height: 200,
                    decoration: BoxDecoration(
                        color: CommonColors.shimmerHigh,
                        borderRadius: BorderRadius.circular(12)
                    )
                  )
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(14),
                  child: Container(
                    padding: EdgeInsets.all(Sizing.space(12)),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: CommonColors.darkTheme2
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(Media.wallet, width: 30, height: 30),
                            const SizedBox(width: 8),
                            SText(
                              text: controller.state.wallet.value.wallet,
                              size: Sizing.font(16),
                              weight: FontWeight.bold,
                              color: CommonColors.lightTheme
                            )
                          ],
                        ),
                        const SizedBox(height: 40),
                        Center(
                          child: SText(
                            text: "Withdrawal Balance",
                            size: Sizing.font(16),
                            color: CommonColors.hint
                          ),
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: SText(
                            text: controller.state.wallet.value.balance,
                            size: Sizing.font(24),
                            weight: FontWeight.bold,
                            color: CommonColors.lightTheme
                          ),
                        ),
                        const SizedBox(height: 10),
                        SText(
                          text: "Deposit",
                          size: Sizing.font(14),
                          color: CommonColors.hint
                        ),
                        const SizedBox(height: 5),
                        SText(
                          text: controller.state.wallet.value.deposit,
                          size: Sizing.font(14),
                          weight: FontWeight.bold,
                          color: CommonColors.lightTheme
                        ),
                        const SizedBox(height: 10),
                        SText(
                          text: "Uncleared Balance",
                          size: Sizing.font(14),
                          color: CommonColors.hint
                        ),
                        const SizedBox(height: 5),
                        SText(
                          text: controller.state.wallet.value.uncleared,
                          size: Sizing.font(14),
                          weight: FontWeight.bold,
                          color: CommonColors.lightTheme
                        ),
                      ],
                    )
                  ),
                );
              }
            }),
            Obx(() {
              if(controller.state.isFetchingWallet.value) {
                return LoadingShimmer(
                  content: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: tabs.length,
                      crossAxisSpacing: 10,
                      mainAxisExtent: 50
                    ),
                    itemCount: tabs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(Sizing.space(10)),
                        decoration: const BoxDecoration(
                          color: CommonColors.darkTheme,
                          shape: BoxShape.circle
                        )
                      );
                    }
                  )
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(14),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: tabs.length,
                      crossAxisSpacing: 15,
                      mainAxisExtent: 70
                    ),
                    itemCount: tabs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      ButtonView tab = tabs[index];
                      return Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              if(index == 0) {
                                FundWalletSheet.open(controller: controller);
                              } else if(index == 1) {
                                WithdrawWalletSheet.open(controller: controller);
                              } else if(index == 2) {
                                Navigate.to(WalletSettingsLayout.route);
                              } else {
                                Get.to(() => Transactions(groups: controller.state.transactions), routeName: Transactions.route);
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.resolveWith((states) {
                                return Theme.of(context).appBarTheme.backgroundColor;
                              }),
                              overlayColor: WidgetStateProperty.resolveWith((states) {
                                return CommonColors.shimmerBase.withOpacity(.48);
                              }),
                              shape: WidgetStateProperty.all(const CircleBorder()),
                            ),
                            tooltip: tab.header,
                            icon: Icon(
                              tab.icon,
                              color: Theme.of(context).primaryColor,
                              size: Sizing.space(18)
                            )
                          ),
                          SText(
                            text: tab.header,
                            size: Sizing.font(11),
                            color: CommonColors.hint
                          ),
                        ],
                      );
                    }
                  ),
                );
              }
            }),
            const SizedBox(height: 30),
            Obx(() {
              if(controller.state.isFetching.value) {
                return LoadingShimmer(
                  content: ListView.builder(
                    itemCount: 6,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(bottom: Sizing.space(5)),
                        padding: const EdgeInsets.all(12.0),
                        height: 70,
                        color: CommonColors.shimmerHigh,
                      );
                    }
                  )
                );
              } else if(controller.state.recents.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SText(
                        text: "Recent Transactions",
                        size: Sizing.font(14),
                        color: CommonColors.hint
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.state.recents.length,
                        itemBuilder: (context, index) {
                          TransactionGroup group = controller.state.recents[index];
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: group.transactions.length,
                            itemBuilder: (context, index) => TransactionBox(transaction: group.transactions[index]),
                          );
                        },
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}