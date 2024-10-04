import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:user/library.dart';

class ShareSheet extends StatelessWidget {
  const ShareSheet({
    super.key,
    required this.link,
    required this.caption,
    this.code = ""
  });

  final String link;
  final String code;
  final String caption;

  static void open({
    required String link,
    String code = "",
    required String caption
  }) {
    Get.bottomSheet(
      ShareSheet(link: link, caption: caption, code: code),
      backgroundColor: Colors.transparent,
      settings: const RouteSettings(name: "/share")
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ButtonView> options = [
      ButtonView(
        index: 0,
        icon: Icons.copy,
        body: "Copy"
      ),
      ButtonView(
        index: 1,
        header: Media.whatsapp,
        body: "WhatsApp"
      ),
      ButtonView(
        index: 2,
        header: Media.twitter,
        body: "Twitter"
      ),
      ButtonView(
        index: 3,
        header: Media.instagram,
        body: "Instagram"
      ),
      ButtonView(
        index: 4,
        header: Media.snapchat,
        body: "Snapchat"
      ),
      ButtonView(
        index: 5,
        header: Media.facebook,
        body: "Facebook"
      ),
      ButtonView(
        index: 6,
        icon: Icons.more_vert_rounded,
        body: "More"
      ),
      ButtonView(
        index: 7,
        icon: Icons.copy,
        body: "Copy code"
      ),
    ];

    return CurvedBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 7,
            margin: EdgeInsets.only(top: Sizing.space(10)),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10)
            )
          ),
          SizedBox(
            height: 180,
            child: GridView.builder(
              itemCount: options.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.2
              ),
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                final share = options[index];
                if(code.isEmpty && share.index == 7) {
                  return Container();
                }
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if(index == 0) {
                        CommonUtility.copy(link);
                      } else if(index == 1) {
                        RouteNavigator.openLink(
                          url: "https://api.whatsapp.com/send?text=$caption\n\n$link"
                        );
                      } else if(index == 2) {
                        RouteNavigator.openLink(
                          url: "https://www.facebook.com/sharer/sharer.php?u=$caption\n\n$link"
                        );
                      } else if(index == 3) {
                        RouteNavigator.openLink(
                          url: "https://www.instagram.com/create/caption/?caption=$caption\n\n$link"
                        );
                      } else if(index == 4) {
                        RouteNavigator.openLink(
                          url: 'https://twitter.com/intent/tweet?text=$caption\n\n$link'
                        );
                      } else if(index == 5) {
                        RouteNavigator.openLink(
                          url: 'snapchat://camera?caption=$caption\n\n$link'
                        );
                      } else if(index == 6) {
                        Share.share("$caption\n\n$link");
                      } else if (index == 7) {
                        CommonUtility.copy(code);
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
                              padding: index == 0 || index == 1 || index == 8
                                ? const EdgeInsets.all(8)
                                : null,
                              color: share.header.isEmpty
                                ? Theme.of(context).primaryColor
                                : share.index == 1
                                ? CommonColors.green
                                : null,
                              height: 40,
                              width: 40,
                              child: share.header.isEmpty
                                ? Icon(
                                  share.icon,
                                  color: Theme.of(context).scaffoldBackgroundColor
                                )
                                : Image.asset(
                                share.header,
                                width: MediaQuery.sizeOf(context).width,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SText(
                            text: share.body,
                            color: Theme.of(context).primaryColor,
                            size: Sizing.font(12),
                            weight: FontWeight.bold,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}