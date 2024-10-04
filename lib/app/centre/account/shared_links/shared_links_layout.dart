import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class SharedLinksLayout extends GetResponsiveView<SharedLinksController> {
  static const String route = "/centre/account/shared-links";
  SharedLinksLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Shared Links",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: Obx(() {
        if(controller.home.state.isFetchingSharedLinks.value) {
          return LoadingShimmer(
            content: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(Sizing.space(10)),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    margin: EdgeInsets.only(bottom: Sizing.space(10)),
                    height: 180,
                    decoration: BoxDecoration(
                      color: CommonColors.shimmerHigh,
                      borderRadius: BorderRadius.circular(6)
                    ),
                  )
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    padding: EdgeInsets.all(Sizing.space(10)),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.sizeOf(context).width,
                        margin: EdgeInsets.only(bottom: Sizing.space(10)),
                        height: 90,
                        decoration: BoxDecoration(
                          color: CommonColors.shimmerHigh,
                          borderRadius: BorderRadius.circular(6)
                        ),
                      );
                    }
                  ),
                ),
              ],
            )
          );
        } else if(controller.home.state.sharedLinks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    Media.world,
                    width: 200
                  ),
                ),
                SText(
                  text: "You have no shared link",
                  color: Theme.of(context).primaryColorDark,
                  size: Sizing.font(20)
                ),
              ],
            )
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(controller.state.showSharedLinks.value) ...[],
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.home.state.sharedLinks.map((link) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SharedLinkItem(link: link),
                        if(controller.home.state.sharedLinks[controller.home.state.sharedLinks.length - 1] != link) ...[
                          const SizedBox(height: 5),
                          Divider(color: Theme.of(context).primaryColor),
                          const SizedBox(height: 5),
                        ]
                      ]
                    );
                  }).toList()
                ),
              )
            ],
          );
        }
      }),
    );
  }
}

class SharedLinkItem extends StatelessWidget {
  final SharedLink link;
  const SharedLinkItem({super.key, required this.link});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Animated(
        toWidget: SharedLinkDetail(link: link),
        toRoute: RouteSettings(name: "/centre/account/links?id=${link.data.linkId}"),
        elevation: 0.0,
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.zero,
        child: Padding(
          padding: EdgeInsets.all(Sizing.space(16)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CategoryImage(image: link.data.image, height: 80, width: 80),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SText(
                            text: link.data.label,
                            size: Sizing.font(14),
                            weight: FontWeight.bold,
                            color: Theme.of(context).primaryColor
                          ),
                          SText(
                            text: link.data.status,
                            size: Sizing.font(12),
                            color: Theme.of(context).primaryColor
                          ),
                          SText(
                            text: link.data.link,
                            size: Sizing.font(12),
                            color: Theme.of(context).primaryColorLight,
                            flow: TextOverflow.ellipsis
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    SText(
                      text: "${link.totalGuests}",
                      size: Sizing.font(14),
                      color: Theme.of(context).primaryColorLight
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}