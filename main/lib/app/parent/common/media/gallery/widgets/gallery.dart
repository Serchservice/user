import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';

class Gallery extends StatefulWidget {
  const Gallery({
    super.key,
    required this.album,
    required this.onPick,
  });

  final Album album;
  final Function(SelectedMedia, Medium) onPick;

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List<Medium> mediums = <Medium>[];

  @override
  void initState() {
    super.initState();
    fetchMedia();
  }

  void fetchMedia() async {
    MediaPage page = await widget.album.listMedia();
    mediums = page.items;
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      backgroundColor: Theme.of(context).bottomAppBarTheme.color,
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "${widget.album.name ?? "Unnamed Album"} (${widget.album.count.toString()})",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if(mediums.isEmpty) {
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
                childAspectRatio: gridWidth / (gridWidth + 30),
                crossAxisCount: 3,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemCount: mediums.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Medium medium = mediums[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Material(
                    child: InkWell(
                      onTap: () async {
                        final file = await medium.getFile();
                        final size = AssetUtility.getFileSize(file: file);
                        SelectedMedia media = SelectedMedia(
                          path: file.path,
                          size: size ?? "",
                          media: MediaType.photo,
                          data: await file.readAsBytes(),
                        );
                        Navigate.back();
                        widget.onPick.call(media, medium);
                      },
                      child: Container(
                        color: Colors.grey[300],
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder: AssetImage(
                            Database.preference.isDarkTheme
                              ? Media.light
                              : Media.dark
                          ),
                          image: ThumbnailProvider(
                            mediumId: medium.id,
                            mediumType: medium.mediumType,
                            highQuality: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      );
    }
  }
}