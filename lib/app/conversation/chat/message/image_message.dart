import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:user/library.dart';

class ImageMessage extends StatefulWidget{
  final ChatMessage message;
  const ImageMessage({super.key, required this.message});

  @override
  State<ImageMessage> createState() => _ImageMessageState();
}

class _ImageMessageState extends State<ImageMessage> {
  Object? imageProvider;
  bool isInitialized = false;
  double? height;
  double? width;

  void initChatImage() async {
    try {
      if(widget.message.message.contains("https")) {
        imageProvider = CachedNetworkImageProvider(widget.message.message);
        setState(() {
          isInitialized = true;
          height = CachedNetworkImageProvider(widget.message.message).maxHeight?.toDouble();
          width = CachedNetworkImageProvider(widget.message.message).maxWidth?.toDouble();
        });
      } else {
        imageProvider = FileImage(File(widget.message.message));
        setState(() {
          isInitialized = true;
        });
      }
    } catch (_) {

    }
  }

  @override
  void initState() {
    super.initState();
    initChatImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: height ?? 300,
        maxWidth: width ?? Get.width
      ),
      child: Stack(
        children: [
          if(imageProvider != null)
          Animated(
            toWidget: ViewImage(
              image: widget.message.message,
              header: "Sent by ${widget.message.name}",
              data: "Message received on ${DateFormat('EEEE MMMM d, y').format(widget.message.sentAt)}"
            ),
            toRoute: RouteSettings(name: "/galler/image/view?=${widget.message.id}"),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: PhotoView(
                imageProvider: imageProvider as ImageProvider,
                loadingBuilder: (context, event) {
                  return Center(child: Loading(color: Theme.of(context).primaryColor));
                },
                errorBuilder: (context, error, stackTrace) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.replay_outlined,
                        color: Theme.of(context).unselectedWidgetColor
                      )
                    )
                  );
                },
              )
            ),
          ),
        ]
      ),
    );
  }
}