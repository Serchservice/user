import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpeakWithSerchTicketLayout extends StatelessWidget {
  final SpeakWithSerch? message;

  const SpeakWithSerchTicketLayout({super.key, this.message});

  static void open({SpeakWithSerch? message}) {
    String baseUrl = "/centre/app/help/speak-with-serch";
    String route = message != null ? "$baseUrl/${message.ticket}" : "$baseUrl/new";

    Navigate.bottomSheet(
      sheet: SpeakWithSerchTicketLayout(message: message),
      background: Colors.transparent,
      isScrollable: message != null,
      safeArea: message == null,
      route: route
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetX<SpeakWithSerchTicketController>(
      init: SpeakWithSerchTicketController(message: message),
      builder: (controller) {
        SpeakWithSerch content = controller.state.message.value;

        return CurvedBottomSheet(
          padding: content.ticket.isNotEmpty ? EdgeInsets.zero : null,
          safeArea: content.ticket.isNotEmpty,
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(controller.hasMessage) ...[
                SpeakWithSerchTicketHeader(message: content),
                Expanded(
                  child: PullToRefresh(
                    onRefreshed: controller.refreshPage,
                    child: SpeakWithSerchTicketList(controller: controller),
                  )
                )
              ],
              if(!controller.hasMessage) ...[
                Expanded(
                  child: Center(
                    child: SText.center(
                      text: "Start issue",
                      color: Theme.of(context).primaryColor,
                      size: Sizing.font(16)
                    ),
                  ),
                )
              ],
              Padding(
                padding: controller.hasMessage ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Field(
                        controller: controller.messageController,
                        padding: const EdgeInsets.all(10),
                        focus: controller.focusNode,
                        inputAction: TextInputAction.newline,
                        isBig: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    LoadingButton(
                      text: "Send",
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizing.space(6),
                        vertical: Sizing.space(12)
                      ),
                      loading: controller.state.isSending.value,
                      onClick: () => controller.send(context),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }
}