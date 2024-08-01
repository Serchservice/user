import 'package:user/library.dart';
import 'package:flutter/material.dart';

class ActiveProviderView extends StatelessWidget {
  final Active active;

  const ActiveProviderView({required this.active, super.key});

  static void open({required Active active}) {
    Navigate.bottomSheet(
      sheet: ActiveProviderView(active: active),
      route: "/dashboard/request/result/view?provider=${active.id}"
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      padding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(Sizing.space(12)),
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.surface,
                    width: 8
                  )
                )
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Avatar.small(avatar: active.avatar),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SText(
                              text: active.name,
                              color: Theme.of(context).primaryColor,
                              size: Sizing.font(16),
                              weight: FontWeight.bold,
                              flow: TextOverflow.ellipsis
                            ),
                            RatingIcon(rating: active.rating),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildVerification(context)
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircledButton(
                        title: "Chat with ${active.name}",
                        icon: Icons.chat,
                        onClick: () => RouteNavigator.openChat(roommate: active.id, removeRoute: true)
                      ),
                      const SizedBox(width: 10),
                      CircledButton(
                        title: "Call ${active.name}",
                        icon: Icons.call,
                        onClick: () => CallOptionSheet.open(name: active.name, id: active.id, avatar: active.avatar)
                      ),
                      const SizedBox(width: 10),
                      CircledButton(
                        title: "Reserve ${active.name}",
                        icon: Icons.calendar_month,
                        onClick: () => ScheduleTimePicker.open(
                          id: active.id,
                          name: active.name,
                          onSchedule: (schedule) {
                            Navigate.offTill(HomeLayout.route, ModalRoute.withName(HomeLayout.route));
                          }
                        )
                      ),
                    ],
                  )
                ],
              )
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(Sizing.space(16)),
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CategoryImage(image: active.image, height: 50, width: 50),
                  const Expanded(child: SizedBox()),
                  _buildStatus(context)
                ],
              ),
            ),
            if(active.more != null) ...[
              const SizedBox(height: 15),
              Divider(color: Theme.of(context).primaryColor),
              const SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(Sizing.space(9)),
                color: Theme.of(context).appBarTheme.backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SText.center(
                      text: 'Account Summary',
                      color: Theme.of(context).primaryColor,
                      size: Sizing.font(16),
                      weight: FontWeight.bold
                    ),
                    const SizedBox(height: 10),
                    SummaryBox(title: "Last Signed In", value: active.more!.lastSignedIn),
                    const SizedBox(height: 5),
                    SummaryBox(title: "Number of Ratings", value: "${active.more!.numberOfRating}"),
                    const SizedBox(height: 5),
                    SummaryBox(title: "Total Service Trips", value: "${active.more!.totalServiceTrips}"),
                    const SizedBox(height: 5),
                    SummaryBox(title: "Number of Shops", value: "${active.more!.numberOfShops}"),
                    const SizedBox(height: 5),
                    SummaryBox(title: "Total Shared Links", value: "${active.more!.totalShared}"),
                  ],
                ),
              ),
              const SizedBox(height: 15),
            ],
            if(active.business != null) ...[
              const SizedBox(height: 15),
              Divider(color: Theme.of(context).primaryColor),
              const SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(Sizing.space(9)),
                color: Theme.of(context).appBarTheme.backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SText.center(
                      text: 'Business Organization ${active.name} belongs to',
                      color: Theme.of(context).primaryColor,
                      size: Sizing.font(16),
                      weight: FontWeight.bold
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Avatar.small(avatar: active.business!.logo),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SText(
                                text: active.business!.name,
                                color: Theme.of(context).primaryColor,
                                size: Sizing.font(16),
                                weight: FontWeight.bold,
                                flow: TextOverflow.ellipsis
                              ),
                              SText(
                                text: active.business!.description,
                                color: Theme.of(context).primaryColor,
                                size: Sizing.font(16),
                                weight: FontWeight.bold,
                                flow: TextOverflow.ellipsis
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ),
              const SizedBox(height: 15),
            ],
            if(active.specializations.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SText.center(
                  text: '${active.name} is very good with these skills:',
                  color: Theme.of(context).primaryColorLight,
                  size: 14
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  runAlignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 5,
                  runSpacing: 5,
                  children: active.specializations.map((service) => Container(
                    padding: EdgeInsets.all(Sizing.space(6)),
                    margin: EdgeInsets.only(bottom: Sizing.space(6)),
                    decoration: BoxDecoration(
                      color: CommonColors.darkTheme2,
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: SText(
                      text: service.special,
                      color: CommonColors.lightTheme,
                    ),
                  )).toList(),
                ),
              )
            ]
          ],
        ),
      )
    );
  }

  Widget _buildStatus(BuildContext context) {
    Color? color = active.status == "ONLINE"
        ? CommonColors.green : active.status != "OFFLINE" ? CommonColors.premium
        : Theme.of(context).appBarTheme.backgroundColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(Sizing.space(4)),
          decoration: BoxDecoration(
            color: CommonUtility.lightenColor(color ?? CommonColors.lightTheme2, 70),
            borderRadius: BorderRadius.circular(6)
          ),
          child: SText.center(
            text: active.status,
            size: Sizing.font(11),
            color: color ?? CommonColors.lightTheme2
          ),
        )
      ],
    );
  }

  Widget _buildVerification(BuildContext context) {
    Color color = active.verificationStatus == "VERIFIED" ? CommonColors.green : CommonColors.payu;

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