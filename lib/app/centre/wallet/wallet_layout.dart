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
      ButtonView(header: "History", icon: Icons.history_rounded),
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
            Obx(() => WalletView(
              isLoading: controller.state.isFetchingWallet.value,
              wallet: controller.state.wallet.value,
            )),
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
                        width: MediaQuery.sizeOf(context).width,
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