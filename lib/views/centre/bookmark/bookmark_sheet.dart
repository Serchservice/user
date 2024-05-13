import 'package:flutter/material.dart';
import 'package:user/library.dart';

class BookmarkSheet extends StatefulWidget {
  final Bookmark bookmark;
  final BookmarkController controller;
  const BookmarkSheet({super.key, required this.bookmark, required this.controller});

  @override
  State<BookmarkSheet> createState() => _BookmarkSheetState();

  static void open({
    required Bookmark bookmark,
    required BookmarkController controller
  }) => Navigate.bottomSheet(
    sheet: BookmarkSheet(
      bookmark: bookmark,
      controller: controller
    ),
    route: "/centre/bookmark/options?id=${bookmark.id}&user=${bookmark.user}",
    background: Colors.transparent
  );
}

class _BookmarkSheetState extends State<BookmarkSheet> {
  final Connect _connect = Connect();
  bool unbookmarking = false;

  void unbookmark () async {
    setState(() {
      unbookmarking = true;
    });
    try {
      var res = await _connect.delete(endpoint: "/bookmark/remove?id=${widget.bookmark.id}");
      ApiResponse response = ApiResponse.fromJson(res.data);
      setState(() {
        unbookmarking = false;
      });
      if(response.isOk) {
        widget.controller.fetchBookmarks();
        Navigate.back();
        SnackBars.top(message: response.message, type: Snackbar.success);
      } else {
        SnackBars.top(message: response.message, type: Snackbar.error);
      }
    } on Exception catch (e) {
      setState(() {
        unbookmarking = false;
      });
      Connect.showError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ButtonView> buttons = [
      ButtonView(
        header: unbookmarking ? "Unbookmarking ${widget.bookmark.name}" : "Unbookmark ${widget.bookmark.name}",
        icon: unbookmarking ? Icons.bookmark_remove_rounded : Icons.bookmark_rounded,
        color: unbookmarking ? CommonColors.hint : CommonColors.yellow,
        index: 0
      ),
      ButtonView(
        header: "Chat with ${widget.bookmark.name}",
        icon: Icons.chat_bubble_rounded,
        color: Theme.of(context).primaryColor,
        index: 1,
        path: ""
      ),
      ButtonView(
        header: "Connect with ${widget.bookmark.name}",
        icon: Icons.connect_without_contact_rounded,
        color: Theme.of(context).primaryColor,
        index: 2,
        path: ""
      ),
    ];

    return CurvedBottomSheet(
      safeArea: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...buttons.map((button) => NavigatorButton(
            header: button.header,
            prefixIcon: button.icon,
            iconColor: button.color,
            onPressed: () {
              if(button.index == 0) {
                unbookmark();
              } else {
                Navigate.to(button.path);
              }
            },
          ))
        ],
      )
    );
  }
}