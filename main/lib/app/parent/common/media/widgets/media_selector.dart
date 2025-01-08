import 'package:user/library.dart';
import 'package:flutter/material.dart';

class MediaSelector extends StatelessWidget {
  final Function(SelectedMedia) onReceived;
  final String route;
  final bool isVideo;
  final String title;
  final bool isChat;
  final String id;
  final String callbackUrl;
  final String name;

  const MediaSelector({
    super.key,
    required this.onReceived,
    required this.route,
    required this.isVideo,
    required this.title,
    required this.isChat,
    required this.id,
    required this.callbackUrl,
    required this.name
  });

  static void open({
    required Function(SelectedMedia) onReceived,
    required String route,
    bool isVideo = false,
    String title = "Pick your avatar",
    bool isChat = false,
    String id = "",
    String callbackUrl = "",
    String name = "",
  }) {
    if(PlatformEngine.instance.isMobile) {
      Navigate.bottomSheet(
        sheet: MediaSelector(
          onReceived: onReceived,
          route: route,
          isVideo: isVideo,
          title: title,
          isChat: isChat,
          id: id,
          callbackUrl: callbackUrl,
          name: name
        ),
        isScrollable: true,
        route: route
      );
    } else {
      notify.info(message: "Picture upload is currently available for mobile");
      return;
    }
  }

  List<ButtonView> options() => [
    ButtonView(icon: Icons.photo_library_rounded, header: "Gallery", index: 0),
    ButtonView(index: 1, icon: Icons.photo_camera_back_rounded, header: "Camera")
  ];

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Theme.of(context).textSelectionTheme.selectionColor,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(Sizing.space(2)),
                      margin: EdgeInsets.all(Sizing.space(6)),
                      alignment: Alignment.center,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.circular(16)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SText(
                                text: "Select your media preference",
                                size: Sizing.font(16),
                                weight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                flow: TextOverflow.ellipsis
                              ),
                              SText(
                                text: "Pick option for media upload",
                                size: Sizing.font(12),
                                color: Theme.of(context).primaryColorLight,
                                flow: TextOverflow.ellipsis
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 30),
                        Image.asset(Media.mapRight, width: 50, height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 20),
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 5,
                runSpacing: 20,
                children: options().map((option) {
                  return MediaSelectorItem(
                    option: option,
                    onTap: () async {
                      dynamic result;
                      if(option.index == 0) {
                        result = await GalleryLayout.to(isChat: isChat, isVideo: isVideo, id: id, title: title);
                      } else {
                        result = await CameraLayout.to(isChat: isChat, name: name, id: id, callbackUrl: callbackUrl);
                      }

                      if(result != null) {
                        onReceived.call(SelectedMedia.fromJson(result));
                      }

                      return;
                    },
                  );
                }).toList(),
              ),
            )
          ],
        ),
      )
    );
  }
}