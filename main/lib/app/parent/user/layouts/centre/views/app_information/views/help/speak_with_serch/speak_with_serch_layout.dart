import 'package:user/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SpeakWithSerchLayout extends GetResponsiveView<SpeakWithSerchController> {
  static const String route = "/centre/app/help/speak-with-serch";
  SpeakWithSerchLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Speak With Serch",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      floatingButton: FloatingActionButton(
        onPressed: () => SpeakWithSerchTicketLayout.open(),
        tooltip: "Create issue",
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        child: Icon(
          FontAwesomeIcons.penToSquare,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: PullToRefresh(
        onRefreshed: controller.refreshList,
        child: PagedListView<int, SpeakWithSerch>(
          pagingController: controller.messageController,
          builderDelegate: PagedChildBuilderDelegate<SpeakWithSerch>(
            itemBuilder: (context, message, index) => SpeakWithSerchItem(message: message),
            firstPageErrorIndicatorBuilder: (context) => PagingFirstPageErrorIndicator(
              error: controller.messageController.error,
              onTryAgain: () => controller.messageController.refresh()
            ),
            firstPageProgressIndicatorBuilder: (_) => PagingFirstPageLoadingIndicator(
              padding: const EdgeInsets.all(12.0),
              height: 80,
            ),
            noItemsFoundIndicatorBuilder: (context) => PagingNoItemFoundIndicator(
              message: "Tell Serch what the problem is",
              icon: CupertinoIcons.ticket_fill,
            ),
            // noMoreItemsIndicatorBuilder: (_) => NoMoreItemsIndicator(),
            // newPageProgressIndicatorBuilder: (_) => NewPageProgressIndicator(),
            // newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
            //   error: controller.messageController.error,
            //   onTryAgain: () => controller.messageController.retryLastFailedRequest(),
            // ),
          ),
        ),
      ),
    );
  }
}