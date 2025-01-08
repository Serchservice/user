import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:user/library.dart';

class BookmarkItemSheet extends StatelessWidget {
  final Bookmark bookmark;

  const BookmarkItemSheet({super.key, required this.bookmark});

  static void open({required Bookmark bookmark}) => Navigate.bottomSheet(
    sheet: BookmarkItemSheet(bookmark: bookmark),
    route: "/centre/bookmark/options?id=${bookmark.id}&user=${bookmark.user}",
    background: Colors.transparent
  );

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      child: GetX<BookmarkItemSheetController>(
        init: BookmarkItemSheetController(bookmark: bookmark),
        builder: (controller) {
          bool isRemoving = controller.state.isRemoving.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ...controller.buttons(isRemoving).map((button) => NavigatorButton(
                header: button.header,
                prefixIcon: button.icon,
                iconColor: button.color,
                onPressed: () => controller.navigate(button),
              ))
            ],
          );
        }
      )
    );
  }
}