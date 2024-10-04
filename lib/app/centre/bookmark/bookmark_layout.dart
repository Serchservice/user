import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class BookmarkLayout extends GetResponsiveView<BookmarkController> {
  static const String route = "/centre/bookmark";
  BookmarkLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Bookmark",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: Obx(() {
        if(controller.state.isFetching.value) {
          return Padding(
            padding: EdgeInsets.all(Sizing.space(16)),
            child: LoadingShimmer(
              content: ListView.builder(
                itemCount: 6,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.sizeOf(context).width,
                    margin: EdgeInsets.only(bottom: Sizing.space(10)),
                    height: 90,
                    decoration: BoxDecoration(
                      color: CommonColors.shimmerHigh,
                      borderRadius: BorderRadius.circular(10)
                    ),
                  );
                }
              )
            )
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(controller.state.showBookmark.value) ...[
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: EdgeInsets.all(Sizing.space(12)),
                  margin: EdgeInsets.all(Sizing.space(10)),
                  decoration: BoxDecoration(
                    color: Theme.of(context).splashColor,
                    borderRadius: BorderRadius.circular(6)
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SText(
                          text: "With bookmark, you get to save providers you love their services"
                          " as long as you want. This makes it faster for you to connect with them,"
                          " chat and do lot more!.\n\nBookmark makes the work easier and faster.",
                          color: Theme.of(context).primaryColor,
                          size: Sizing.font(9)
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        tooltip: "Close notification",
                        onPressed: () => controller.stopShowingBookmark(),
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).primaryColor,
                        )
                      )
                    ],
                  )
                ),
                const SizedBox(height: 20),
              ],
              if(controller.state.bookmarks.isEmpty) ...[
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: 0.2,
                          child: Icon(
                            Icons.bookmarks_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 100
                          ),
                        ),
                        const SizedBox(height: 10),
                        SText.center(
                          text: "You do not have any bookmarks",
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  )
                )
              ],
              if(controller.state.bookmarks.isNotEmpty) ...[
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: controller.state.bookmarks.map((bookmark) => Column(
                      children: [
                        Stack(
                          children: [
                            Material(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: InkWell(
                                onTap: () => BookmarkSheet.open(
                                  bookmark: bookmark,
                                  controller: controller
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(Sizing.space(12)),
                                  child: Row(
                                    children: [
                                      Avatar.medium(avatar: bookmark.avatar),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SText(
                                              text: bookmark.name,
                                              size: Sizing.space(14),
                                              color: Theme.of(context).primaryColor,
                                            ),
                                            Row(
                                              children: [
                                                RatingIcon(
                                                  rating: bookmark.rating,
                                                  iconSize: 16,
                                                  textSize: 9,
                                                ),
                                                const SizedBox(width: 4),
                                                const SizedBox(width: 4),
                                                SText.center(
                                                  text: "(${bookmark.category})",
                                                  size: Sizing.space(9),
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                              ],
                                            ),
                                            SText.center(
                                              text: "Last Signed In: ${bookmark.lastSignedIn}",
                                              size: Sizing.space(9),
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ],
                                        )
                                      ),
                                    ],
                                  ),
                                )
                              )
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: CategoryImage(
                                image: bookmark.image,
                                height: 80,
                              ),
                            )
                          ],
                        ),
                        Divider(color: Theme.of(context).primaryColor),
                      ],
                    )).toList(),
                  )
                )
              ]
            ],
          );
        }
      }),
    );
  }
}