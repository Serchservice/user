import 'package:flutter/material.dart';
import 'package:user/library.dart';

class BookmarkItem extends StatelessWidget {
  final Bookmark bookmark;

  const BookmarkItem({super.key, required this.bookmark});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: InkWell(
            onTap: () => BookmarkItemSheet.open(bookmark: bookmark),
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
                          spacing: 6,
                          children: [
                            RatingIcon(rating: bookmark.rating, iconSize: 16, textSize: 9,),
                            SText.center(
                              text: "(${bookmark.category})",
                              size: Sizing.space(9),
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                        SText.center(
                          text: bookmark.lastSignedIn,
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
          child: CategoryImage(image: bookmark.image, height: 80,),
        )
      ],
    );
  }
}
