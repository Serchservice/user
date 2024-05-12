import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:user/library.dart';

/// {"isVideo": "false", "title": "Pick Your Avatar", "isChat": "false", "receiver": "12345"}
class GalleryLayout extends GetResponsiveView<GalleryController> {
  static String get route => "/gallery";
  GalleryLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
      backgroundColor: Theme.of(context).bottomAppBarTheme.color,
      appbar: AppBar(
        elevation: 0.5,
        title: Obx(() => SText.center(
          text: controller.state.title.value,
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        )),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CentreNavigator(
            tab: ButtonView(
              icon: Icons.photo_library_rounded,
              header: "Select from file manager",
              body: "You can select up to 30mb of photo size",
            ),
            onTap: () => controller.pickFromFile(),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: SText(
              text: "Gallery ${controller.state.isVideo.value ? "Video" : "Photo"} Albums",
              color: Theme.of(context).primaryColorLight,
              size: Sizing.font(14),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              if(controller.state.albums.isEmpty) {
                return Container();
              } else {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    double gridWidth = (constraints.maxWidth - 20) / 3;
                    return Scrollbar(
                      thickness: 5.0,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(12.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: gridWidth / (gridWidth + 50),
                          crossAxisCount: 3,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                        ),
                        itemCount: controller.state.albums.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Album album = controller.state.albums[index];
                          return Animated(
                            toWidget: Gallery(
                              album: album,
                              onPick: (media, medium) {
                                if(controller.state.isChat.value) {
                                  //
                                } else {
                                  Navigate.back(result: media);
                                }
                              },
                            ),
                            borderRadius: BorderRadius.zero,
                            toRoute: RouteSettings(name: "/gallery/album?id=${album.id}"),
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.grey[300],
                                  height: gridWidth,
                                  width: gridWidth,
                                  child: FadeInImage(
                                    fit: BoxFit.cover,
                                    placeholder: AssetImage(
                                      Database.preference.isDarkTheme
                                        ? Media.light
                                        : Media.dark
                                    ),
                                    image: AlbumThumbnailProvider(
                                      album: album,
                                      highQuality: true,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: SText.center(
                                          text: album.name ?? "Unnamed Album",
                                          size: Sizing.font(9),
                                          color: Theme.of(context).primaryColor,
                                          flow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      ),
                    );
                  }
                );
              }
            }),
          )
        ],
      )
    );
  }
}