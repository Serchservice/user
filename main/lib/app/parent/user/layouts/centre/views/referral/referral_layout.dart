import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ReferralLayout extends GetResponsiveView<ReferralController> {
  static const String route = "/centre/referral";
  ReferralLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Referral",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
        actions: [
          InfoButton(onPressed: ReferralProgramView.open)
        ],
      ),
      child: PullToRefresh(
        onRefreshed: controller.referralController.refresh,
        child: PagedListView<int, Referral>(
          pagingController: controller.referralController,
          builderDelegate: PagedChildBuilderDelegate<Referral>(
            itemBuilder: (context, referral, index) => ReferralItem(referral: referral),
            firstPageErrorIndicatorBuilder: (context) => PagingFirstPageErrorIndicator(
              error: controller.referralController.error,
              onTryAgain: () => controller.referralController.refresh()
            ),
            firstPageProgressIndicatorBuilder: (_) => PagingFirstPageLoadingIndicator(
              height: 70,
            ),
            noItemsFoundIndicatorBuilder: (context) => PagingNoItemFoundIndicator(
              message: "You don't have any referrals",
              icon: Icons.account_tree_rounded,
            ),
            // noMoreItemsIndicatorBuilder: (_) => NoMoreItemsIndicator(),
            // newPageProgressIndicatorBuilder: (_) => NewPageProgressIndicator(),
            // newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
            //   error: controller.referralController.error,
            //   onTryAgain: () => controller.referralController.retryLastFailedRequest(),
            // ),
          ),
        ),
      )
    );
  }
}