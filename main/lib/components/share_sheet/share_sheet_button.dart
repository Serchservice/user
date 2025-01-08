import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareSheetButton extends StatelessWidget {
  final ButtonView share;
  final String message;
  final String data;
  final bool withTitle;

  const ShareSheetButton({
    super.key,
    required this.share,
    required this.message,
    required this.data,
    this.withTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if(share.index == 0) {
            CommonUtility.copy(data);
          } else if(share.index == 1) {
            RouteNavigator.openLink(url: "https://api.whatsapp.com/send?text=$message");
          } else if(share.index == 2) {
            RouteNavigator.openLink(url: "https://www.facebook.com/sharer/sharer.php?u=$message");
          } else if(share.index == 3) {
            RouteNavigator.openLink(url: "https://www.instagram.com/create/caption/?caption=$message");
          } else if(share.index == 4) {
            RouteNavigator.openLink(url: 'https://twitter.com/intent/tweet?text=$message');
          } else if(share.index == 5) {
            RouteNavigator.openLink(url: 'snapchat://camera?caption=$message');
          } else if(share.index == 6) {
            Share.share(message);
          }
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: share.index == 0 || share.index == 1 || share.index == 8 ? const EdgeInsets.all(8) : null,
                  color: share.header.isEmpty ? Theme.of(context).primaryColor : share.index == 1 ? CommonColors.green : null,
                  height: 40,
                  width: 40,
                  child: share.header.isEmpty
                    ? Icon(share.icon, color: Theme.of(context).scaffoldBackgroundColor)
                    : Image.asset(share.header, width: MediaQuery.sizeOf(context).width,),
                ),
              ),
              if(withTitle) ...[
                const SizedBox(height: 10),
                SText(
                  text: share.body,
                  color: Theme.of(context).primaryColor,
                  size: Sizing.font(12),
                  weight: FontWeight.bold,
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  static List<ButtonView> options = [
    ButtonView(index: 0, icon: Icons.copy, body: "Copy"),
    ButtonView(index: 1, header: Media.whatsapp, body: "WhatsApp"),
    ButtonView(index: 2, header: Media.twitter, body: "Twitter"),
    ButtonView(index: 3, header: Media.instagram, body: "Instagram"),
    ButtonView(index: 4, header: Media.snapchat, body: "Snapchat"),
    ButtonView(index: 5, header: Media.facebook, body: "Facebook"),
    ButtonView(index: 6, icon: Icons.more_vert_rounded, body: "More"),
  ];
}
