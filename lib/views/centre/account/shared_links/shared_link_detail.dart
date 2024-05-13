import 'package:flutter/material.dart';
import 'package:user/library.dart';

class SharedLinkDetail extends StatelessWidget {
  final SharedLink link;
  const SharedLinkDetail({super.key, required this.link});

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: link.data.label,
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
        actions: [
          IconButton(
            onPressed: () => ShareSheet.open(
              link: link.data.link,
              code: "",
              caption: "Share Link"
            ),
            tooltip: "Share Link",
            icon: Icon(
              Icons.share_rounded,
              color: Theme.of(context).primaryColor
            )
          )
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(child: CategoryImage(image: link.data.image)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SText(
                text: "Link Details",
                color: Theme.of(context).primaryColor,
                size: Sizing.font(16),
                weight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: EdgeInsets.all(Sizing.space(16)),
              color: Theme.of(context).bottomAppBarTheme.color,
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(120)
                },
                children: [
                  _buildTile(
                    context: context,
                    key: "ID",
                    value: link.data.linkId
                  ),
                  _buildTile(
                    context: context,
                    key: "Link",
                    value: link.data.link
                  ),
                  _buildTile(
                    context: context,
                    key: "Amount Spent",
                    value: link.data.amount
                  ),
                  _buildTile(
                    context: context,
                    key: "Created At",
                    value: link.data.label
                  ),
                  _buildTile(
                    context: context,
                    key: "Current Status",
                    value: link.data.status
                  ),
                  _buildTile(
                    context: context,
                    key: "Category",
                    value: link.data.category
                  ),
                  _buildTile(
                    context: context,
                    key: "Total Guests",
                    value: "${link.totalGuests}"
                  ),
                ],
              )
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SText(
                text: "Provider",
                color: Theme.of(context).primaryColor,
                size: Sizing.font(16),
                weight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: EdgeInsets.all(Sizing.space(6)),
              color: Theme.of(context).bottomAppBarTheme.color,
              child: SharedPersonInformation(
                avatar: link.data.provider.avatar,
                name: link.data.provider.name,
                category: link.data.provider.category,
                rating: link.data.provider.rating
              )
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SText(
                text: "Guests",
                color: Theme.of(context).primaryColor,
                size: Sizing.font(16),
                weight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(link.guests.isNotEmpty) ...[
                  ...link.guests.map((guest) => SharedPersonInformation(
                    avatar: guest.avatar,
                    name: guest.name,
                    category: guest.status,
                    onTap: () => SharedLinkGuestDetail.open(
                      id: link.data.linkId,
                      guest: guest
                    )
                  ))
                ],
                if(link.guests.isEmpty) ...[
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        SText(
                          text: "There are no guests attached to this link",
                          color: Theme.of(context).primaryColor,
                          size: Sizing.font(16),
                          weight: FontWeight.bold
                        ),
                      ],
                    ),
                  )
                ]
              ],
            ),
          ],
        )
      )
    );
  }

  TableRow _buildTile({required BuildContext context, required String key, required String value}) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: Sizing.space(6)),
          child: SText(
            autoSize: false,
            text: key,
            color: Theme.of(context).primaryColor,
            size: Sizing.font(12),
            weight: FontWeight.bold
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: Sizing.space(6)),
          child: SText(
            autoSize: false,
            text: value,
            color: Theme.of(context).primaryColor,
            size: Sizing.font(12),
          ),
        ),
      ]
    );
  }
}

class SharedPersonInformation extends StatelessWidget {
  final String avatar;
  final String name;
  final String category;
  final double? rating;
  final VoidCallback? onTap;
  const SharedPersonInformation({
    super.key,
    required this.avatar,
    required this.name,
    required this.category,
    this.rating,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(Sizing.space(6)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Avatar.small(avatar: avatar),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SText(
                      text: name,
                      size: Sizing.font(15),
                      color: Theme.of(context).primaryColor
                    ),
                    SText(
                      text: category,
                      size: Sizing.font(12),
                      color: Theme.of(context).primaryColor
                    ),
                  ],
                )
              ),
              if(rating != null) ...[
                RatingIcon(rating: rating!)
              ]
            ],
          ),
        ),
      )
    );
  }
}