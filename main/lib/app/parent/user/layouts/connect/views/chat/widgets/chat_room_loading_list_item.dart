import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ChatRoomLoadingListItem extends StatelessWidget {
  const ChatRoomLoadingListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingShimmer(
      content: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.all(12.0),
        child: Row(
          spacing: 6,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(backgroundColor: CommonColors.shimmerHigh, radius: 28),
            Expanded(
              child: Column(
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: _buildLoader(15)),
                      _buildLoader(12, width: 100)
                    ],
                  ),
                  Row(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: _buildLoader(15)),
                      CircleAvatar(backgroundColor: CommonColors.shimmerHigh, radius: 10),
                    ]
                  ),
                ],
              )
            )
          ],
        ),
      )
    );
  }

  Widget _buildLoader(double height, {double? width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(color: CommonColors.shimmerHigh, borderRadius: BorderRadius.circular(4)),
    );
  }
}