import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ProviderResultLayout extends StatelessWidget {
  final Active active;
  final bool isBest;
  const ProviderResultLayout({super.key, required this.active, required this.isBest});

  static void open({required Active active, bool isBest = false}) {
    Navigate.bottomSheet(
      sheet: ProviderResultLayout(active: active, isBest: isBest),
      route: "/provider/${active.id}",
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).primaryColor;
    Color bgColor = Theme.of(context).scaffoldBackgroundColor;
    Color hintColor = CommonColors.hint;

    return CurvedBottomSheet(
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.zero,
      safeArea: true,
      child: GetBuilder<ProviderResultController>(
        init: ProviderResultController(active: active),
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Color(0xffe0fbfc),
                  width: MediaQuery.sizeOf(context).width,
                  padding: EdgeInsets.all(12),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Material(
                          color: bgColor,
                          child: InkWell(
                            onTap: () => Navigate.back(),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(Icons.close, color: textColor),
                            ),
                          ),
                        ),
                      ),
                      Center(child: Image(image: AssetUtility.image(active.image), height: 220)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Avatar.medium(avatar: active.avatar),
                          Expanded(
                            child: Row(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SText(text: active.name, size: Sizing.space(14), weight: FontWeight.w600, color: textColor),
                                      SText(text: active.category, size: Sizing.space(12), color: hintColor),
                                    ],
                                  ),
                                ),
                                RatingIcon(rating: active.rating, color: textColor),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 12,
                        children: [
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: bgColor),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(CupertinoIcons.circle_grid_hex_fill, color: textColor),
                            ),
                          ),
                          Container(width: 2, height: 30, color: hintColor),
                          Expanded(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 60),
                              child: ListView.separated(
                                itemCount: controller.buttons.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) {
                                  return SizedBox(width: 4);
                                },
                                itemBuilder: (context, index) {
                                  ButtonView view = controller.buttons[index];

                                  return CircledButton(
                                    title: view.header,
                                    icon: view.icon,
                                    backgroundColor: CommonUtility.lightenColor(hintColor, 35),
                                    iconColor: textColor,
                                    onClick: () => controller.onClick(view)
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: hintColor, width: 1)
                        ),
                        child: Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SText(
                                  text: 'Account Summary',
                                  color: textColor,
                                  size: Sizing.font(16),
                                  weight: FontWeight.bold
                                ),
                                Spacer(),
                                _buildVerification(context)
                              ],
                            ),
                            const SizedBox(height: 5),
                            SummaryItem(title: "Status", value: active.status),
                            SummaryItem(title: "Distance", value: active.distanceInKm),
                            if(active.more != null) ...[
                              SummaryItem(title: "Last Signed In", value: active.more!.lastSignedIn),
                              SummaryItem(title: "Number of Ratings", value: "${active.more!.numberOfRating}"),
                              SummaryItem(title: "Total Service Trips", value: "${active.more!.totalServiceTrips}"),
                              SummaryItem(title: "Number of Shops", value: "${active.more!.numberOfShops}"),
                              SummaryItem(title: "Total Shared Links", value: "${active.more!.totalShared}"),
                            ]
                          ],
                        ),
                      ),
                      if(active.business != null) ...[
                        Container(
                          padding: EdgeInsets.all(Sizing.space(9)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: hintColor, width: 1)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SText.center(
                                text: 'Business organization ${active.name} belongs to',
                                color: textColor,
                                size: Sizing.font(12),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Avatar.small(avatar: active.business!.logo),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SText(
                                          text: active.business!.name,
                                          color: textColor,
                                          size: Sizing.font(14),
                                          weight: FontWeight.bold,
                                        ),
                                        SText(
                                          text: active.business!.description,
                                          color: hintColor,
                                          autoSize: false,
                                          flow: TextOverflow.ellipsis,
                                          size: Sizing.font(11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if(active.business!.address.isNotEmpty) ...[
                                const SizedBox(height: 5),
                                SText(text: "Business Address", color: textColor, autoSize: false, size: 11),
                                SText(
                                  text: active.business!.address,
                                  color: hintColor,
                                  size: Sizing.font(12),
                                ),
                              ]
                            ],
                          )
                        ),
                      ],
                      if(active.specializations.isNotEmpty) ...[
                        SizedBox(height: 10),
                        SText.center(
                          text: '${active.name} is very good with these skills:',
                          color: textColor,
                          size: 12
                        ),
                        Wrap(
                          runAlignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 5,
                          runSpacing: 5,
                          children: active.specializations.map((service) => Container(
                            padding: EdgeInsets.all(Sizing.space(6)),
                            decoration: BoxDecoration(
                              color: textColor,
                              borderRadius: BorderRadius.circular(16)
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 4,
                              children: [
                                Icon(CupertinoIcons.gift_fill, color: bgColor, size: 16),
                                SText(text: service.special, color: bgColor, size: 11, autoSize: false),
                              ],
                            ),
                          )).toList(),
                        )
                      ]
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      )
    );
  }

  Widget _buildVerification(BuildContext context) {
    Color color = active.verificationStatus == "VERIFIED" ? CommonColors.success : CommonColors.payu;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(Sizing.space(4)),
          decoration: BoxDecoration(
            color: CommonUtility.lightenColor(color, 70),
            borderRadius: BorderRadius.circular(6)
          ),
          child: SText.center(
            text: active.verificationStatus.replaceAll("_", " "),
            size: Sizing.font(11),
            color: color
          ),
        )
      ],
    );
  }
}