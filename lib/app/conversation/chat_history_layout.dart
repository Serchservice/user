import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ChatHistoryLayout extends StatefulWidget {
  final HomeController controller;
  const ChatHistoryLayout({super.key, required this.controller});

  @override
  State<ChatHistoryLayout> createState() => _ChatHistoryLayoutState();
}

class _ChatHistoryLayoutState extends State<ChatHistoryLayout> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(widget.controller.state.isFetchingChats.value) {
        return LoadingShimmer(
          content: ListView.builder(
            itemCount: 12,
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
      } else if(widget.controller.state.chats.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Opacity(
                opacity: 0.5,
                child: CategoryImage(
                  image: Media.serchChat,
                  width: 250
                ),
              ),
              const SizedBox(height: 6),
              SText(
                text: "No chats",
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
                  list: widget.controller.messaging.filters,
                  selectedIndex: widget.controller.state.currentChatFilter.value,
                  onSelect: (view) => widget.controller.messaging.filterChats(view.index)
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.controller.state.filteredChats.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return _buildItem(
                    context: context,
                    room: widget.controller.state.filteredChats[index]
                  );
                }
              )
            ],
          )
        );
      }
    });
  }

  Widget _buildItem({required BuildContext context, required ChatRoom room}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => RouteNavigator.openChat(room: room),
        child: Padding(
          padding: EdgeInsets.all(Sizing.space(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Avatar.small(avatar: room.avatar),
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
                            text: room.name,
                            size: Sizing.font(15),
                            color: Theme.of(context).primaryColor,
                            flow: TextOverflow.ellipsis
                          ),
                        ),
                        const SizedBox(width: 10),
                        SText(
                          text: room.label,
                          size: Sizing.font(12),
                          color: Theme.of(context).primaryColor
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MessageStatusIcon(status: room.status),
                              const SizedBox(width: 3),
                              Expanded(
                                child: SText(
                                  text: room.message,
                                  size: Sizing.font(14),
                                  color: Theme.of(context).primaryColor,
                                  flow: TextOverflow.ellipsis
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        _buildCount(context: context, count: room.count),
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

  Widget _buildCount({required BuildContext context, required int count}) {
    if(count >= 1) {
      return CircleAvatar(
        radius: 11,
        backgroundColor: CommonColors.darkTheme2,
        child: Center(
          child: SText.center(
            text: count.toString(),
            color: CommonColors.lightTheme,
            size: Sizing.font(9)
          )
        ),
      );
    } else {
      return Container();
    }
  }
}

class MessageStatusIcon extends StatelessWidget {
  final String status;
  const MessageStatusIcon({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Icon(
      status.toLowerCase() == "sending"
        ? Icons.timelapse
        : status.toLowerCase() == "read"
        ? Icons.done_all_rounded
        : Icons.done_rounded,
      color: Theme.of(context).primaryColor,
      size: Sizing.font(16),
    );
  }
}