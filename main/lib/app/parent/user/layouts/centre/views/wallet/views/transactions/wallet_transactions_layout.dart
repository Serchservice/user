import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class WalletTransactionsLayout extends GetResponsiveView<WalletTransactionsController> {
  static String get route => "/centre/wallet/transactions";

  WalletTransactionsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Transaction History",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: PullToRefresh(
        onRefreshed: controller.transactionController.refresh,
        child: PagedListView<int, TransactionGroup>(
          pagingController: controller.transactionController,
          padding: EdgeInsets.all(10),
          builderDelegate: PagedChildBuilderDelegate<TransactionGroup>(
            itemBuilder: (context, group, index) {
              return Expandable(
                header: SText(
                  text: group.label,
                  size: Sizing.font(14),
                  color:Theme.of(context).primaryColor
                ),
                content: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: group.transactions.length,
                  itemBuilder: (context, index) => WalletTransactionItem(transaction: group.transactions[index]),
                )
              );
            },
            firstPageErrorIndicatorBuilder: (context) => PagingFirstPageErrorIndicator(
              error: controller.transactionController.error,
              onTryAgain: () => controller.transactionController.refresh()
            ),
            firstPageProgressIndicatorBuilder: (_) => PagingFirstPageLoadingIndicator(
              height: 70,
            ),
            noItemsFoundIndicatorBuilder: (context) => PagingNoItemFoundIndicator(
              message: "No transactions",
              customIcon: CategoryImage(image: Media.wallet, width: 250),
            ),
            // noMoreItemsIndicatorBuilder: (_) => NoMoreItemsIndicator(),
            // newPageProgressIndicatorBuilder: (_) => NewPageProgressIndicator(),
            // newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
            //   error: controller.transactionController.error,
            //   onTryAgain: () => controller.transactionController.retryLastFailedRequest(),
            // ),
          ),
        ),
      )
    );
  }
}
