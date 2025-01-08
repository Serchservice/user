import 'package:user/library.dart';
import 'package:flutter/material.dart';

class SharedLinkItem extends StatelessWidget {
  final SharedLink link;
  const SharedLinkItem({super.key, required this.link});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Animated(
        toWidget: SharedLinkDetail(link: link),
        route: "/centre/account/links",
        params: {"id": link.data.linkId},
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