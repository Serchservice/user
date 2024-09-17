import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class CallHistoryLayout extends StatelessWidget {
  final HomeController controller;
  const CallHistoryLayout({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(controller.state.isFetchingCalls.value) {
        return LoadingShimmer(
          content: ListView.builder(
            itemCount: 12,
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
      } else if(controller.state.calls.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Opacity(
                opacity: 0.2,
                child: CategoryImage(
                  image: Media.voiceCall,
                  width: 250
                ),
              ),
              const SizedBox(height: 6),
              SText(
                text: "No calls",
                color: Theme.of(context).primaryColorDark,
                size: Sizing.font(16)
              ),
            ],
          )
        );
      } else {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SearchFilter(
                  list: controller.call.filters,
                  selectedIndex: controller.state.currentCallFilter.value,
                  onSelect: (view) {
                    controller.state.currentCallFilter.value = view.index;
                    controller.state.filteredCalls.value = controller.state.calls;
                    if(view.index == 0) {
                      return;
                    } else if(view.index == 1) {
                      controller.state.filteredCalls.value = controller.state.filteredCalls.where((call) => call.recent.isMissed).toList();
                    } else if(view.index == 2) {
                      controller.state.filteredCalls.value = controller.state.filteredCalls.where((call) => call.recent.outgoing).toList();
                    } else if(view.index == 3) {
                      controller.state.filteredCalls.value = controller.state.filteredCalls.where((call) => !call.recent.outgoing).toList();
                    } else {
                      controller.state.filteredCalls.value = controller.state.filteredCalls.where((call) => call.recent.isT2F).toList();
                    }
                  }
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.state.filteredCalls.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return _buildItem(
                    context: context,
                    call: controller.state.filteredCalls[index]
                  );
                }
              )
            ],
          )
        );
      }
    });
  }

  Widget _buildItem({required BuildContext context, required CallResponse call}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => CallHistoryView.open(call),
        child: Padding(
          padding: EdgeInsets.all(Sizing.space(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Avatar.small(avatar: call.member.avatar),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SText(
                            text: call.member.name,
                            size: Sizing.font(14),
                            color: Theme.of(context).primaryColor,
                            flow: TextOverflow.ellipsis
                          ),
                        ),
                        const SizedBox(width: 10),
                        SText(
                          text: call.member.category,
                          size: Sizing.font(12),
                          color: Theme.of(context).primaryColor
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        getCallIcon(call.recent),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SText(
                                  text: call.recent.label,
                                  size: Sizing.font(11),
                                  color: Theme.of(context).primaryColorLight,
                                  flow: TextOverflow.ellipsis
                                ),
                              ),
                              SText(
                                text: call.recent.duration,
                                size: Sizing.font(11),
                                color: Theme.of(context).primaryColorLight,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ),
            ],
          ),
        )
      )
    );
  }
}

Icon getCallIcon(CallHistory history) {
  return Icon(
    history.outgoing && history.isMissed
      ? Icons.call_missed_outgoing_rounded
      : !history.outgoing && history.isMissed
      ? Icons.call_missed
      : history.isDeclined
      ? Icons.disabled_visible_outlined
      : !history.outgoing
      ? Icons.call_received_outlined
      : Icons.call_made_rounded,
    color: history.outgoing && history.isMissed
      ? CommonColors.premium
      : history.isMissed
      ? CommonColors.error
      : history.isDeclined
      ? CommonColors.hint
      : CommonColors.green,
    size: 18
  );
}