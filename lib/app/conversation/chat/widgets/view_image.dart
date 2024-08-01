import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:user/library.dart';

class ViewImage extends StatefulWidget {
  final String image;
  final String header;
  final String data;
  const ViewImage({super.key, required this.image, required this.header, required this.data});

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  bool loadingImage = true;
  late Object imagePath;

  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  void fetchImage() {
    setState(() => loadingImage = true);
    imagePath = AssetUtility.image(widget.image);
    setState(() => loadingImage = false);
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText(
          text: widget.header,
          color: Theme.of(context).primaryColor,
          size: Sizing.font(16)
        ),
      ),
      child: Stack(
        children: [
          PhotoView(
            imageProvider: imagePath as ImageProvider,
            loadingBuilder: (context, event) {
              return Center(child: Loading(color: Theme.of(context).primaryColor));
            },
            errorBuilder: (context, error, stackTrace) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: fetchImage,
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
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(Sizing.space(8)),
              color: Theme.of(context).bottomAppBarTheme.color,
              child: SText(
                text: widget.data,
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