import 'package:flutter/material.dart';
import 'package:user/library.dart';

class SharedLinkGuestDetail extends StatelessWidget {
  final GuestData guest;
  const SharedLinkGuestDetail({super.key, required this.guest});

  static void open({required GuestData guest, required String id}) => Navigate.bottomSheet(
    sheet: SharedLinkGuestDetail(guest: guest),
    route: "/centre/account/links?id=$id&guest=${guest.id}",
    isScrollable: true
  );

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      padding: EdgeInsets.zero,
      safeArea: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(Sizing.space(12)),
            width: MediaQuery.sizeOf(context).width,
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SText(
                        text: guest.name,
                        size: Sizing.font(15),
                        color: Theme.of(context).scaffoldBackgroundColor
                      ),
                      SText(
                        text: "Joined At: ${guest.joinedAt}",
                        size: Sizing.font(15),
                        color: Theme.of(context).scaffoldBackgroundColor
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Avatar.small(avatar: guest.avatar)
              ],
            ),
          ),
          const SizedBox(height: 15),
          if(guest.statuses.isEmpty) ...[
            const SizedBox(height: 20),
            Center(
              child: SText(
                text: "No events yet",
                size: Sizing.font(15),
                color: Theme.of(context).primaryColor
              ),
            ),
            const SizedBox(height: 20),
          ] else ...[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: guest.statuses.map((status) {
                    return _buildContent(context: context, status: status);
                  }).toList()
                )
              )
            ),
          ]
        ],
      )
    );
  }

  Widget _buildContent({required BuildContext context, required GuestStatus status}) {
    return Container(
      padding: EdgeInsets.all(Sizing.space(9)),
      margin: EdgeInsets.all(Sizing.space(9)),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SText(
            text: "Trip: ${status.trip}",
            color: CommonColors.hint,
            size: Sizing.font(12),
          ),
          const SizedBox(height: 5),
          Divider(color: Theme.of(context).primaryColor),
          Table(
            children: [
              _buildTile(
                context: context,
                key: "Status",
                value: status.status
              ),
              _buildTile(
                context: context,
                key: "Amount",
                value: status.amount
              ),
              _buildTile(
                context: context,
                key: "User share",
                value: status.user
              ),
              _buildTile(
                context: context,
                key: "Event Time",
                value: status.label
              ),
              _buildTile(
                context: context,
                key: "Summary",
                value: status.more
              ),
            ]
          )
        ],
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