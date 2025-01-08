import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:user/library.dart';

class ChatRoomViewImageMessage extends StatelessWidget {
  final String image;
  final String header;
  final String data;

  const ChatRoomViewImageMessage({
    super.key,
    required this.image,
    required this.header,
    required this.data
  });

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText(
          text: header,
          color: Theme.of(context).primaryColor,
          size: Sizing.font(16)
        ),
      ),
      child: Stack(
        children: [
          PhotoView(
            imageProvider: AssetUtility.image(image),
            loadingBuilder: (context, event) {
              return Center(child: Loading(color: Theme.of(context).primaryColor));
            },
            errorBuilder: (context, error, stackTrace) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Icon(
                    Icons.replay_outlined,
                    color: Theme.of(context).unselectedWidgetColor
                  )
                )
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.all(Sizing.space(8)),
              color: Theme.of(context).bottomAppBarTheme.color,
              child: SText(
                text: data,
                color: Theme.of(context).primaryColor,
                size: Sizing.font(14)
              )
            ),
          )
        ],
      )
    );
  }
}