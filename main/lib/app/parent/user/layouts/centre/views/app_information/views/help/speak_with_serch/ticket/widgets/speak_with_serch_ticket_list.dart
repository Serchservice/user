import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:user/library.dart';

class SpeakWithSerchTicketList extends StatelessWidget {
  final SpeakWithSerchTicketController controller;

  const SpeakWithSerchTicketList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 2,
      child: Obx(() {
        if(controller.state.isFetching.value) {
          return PagingFirstPageLoadingIndicator(
            padding: const EdgeInsets.all(12.0),
            height: 90,
            borderRadius: BorderRadius.circular(6)
          );
        } else if(controller.state.error.value.isNotEmpty) {
          return PagingFirstPageErrorIndicator(
            error: controller.state.error.value,
            onTryAgain: () => controller.refreshPage()
          );
        } else if(controller.state.message.value.issues.isEmpty) {
          return PagingNoItemFoundIndicator(message: "Start issue", icon: CupertinoIcons.ticket);
        } else {
          return SingleChildScrollView(
            reverse: true,
            controller: controller.messageScrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(controller.state.isLoadingMore.value) ...[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: CircularProgressIndicator(color: CommonColors.hint, strokeWidth: 4),
                    ),
                  )
                ],
                ...controller.state.message.value.issues.map((issue) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: Sizing.space(8)),
                    child: SpeakWithSerchIssueCard(issue: issue),
                  );
                }),
              ]
            ),
          );
        }
      }),
    );
  }
}
