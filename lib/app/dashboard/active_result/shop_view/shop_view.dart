import 'package:user/library.dart';
import 'package:flutter/material.dart';

class ShopView extends StatefulWidget {
  final Shop shop;
  final double longitude;
  final double latitude;

  const ShopView({required this.shop, super.key, required this.longitude, required this.latitude});

  @override
  State<ShopView> createState() => _ShopViewState();

  static void open({required Shop shop, required double latitude, required double longitude}) {
    Navigate.bottomSheet(
      sheet: ShopView(shop: shop, latitude: latitude, longitude: longitude),
      route: "/dashboard/request/result/view?shop=${shop.id}"
    );
  }
}

class _ShopViewState extends State<ShopView> {
  int current = 0;

  void updateTab(int index) {
    setState(() => current = index);
  }

  @override
  Widget build(BuildContext context) {
    List<String> tabs = ["Business Hours", "Services", "Profile Details"];

    return CurvedBottomSheet(
      padding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(Sizing.space(12)),
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Avatar.small(avatar: widget.shop.logo),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SText(
                          text: widget.shop.name,
                          color: Theme.of(context).primaryColor,
                          size: Sizing.font(16),
                          weight: FontWeight.bold,
                          flow: TextOverflow.ellipsis
                        ),
                        RatingIcon(rating: widget.shop.rating),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircledButton(
                    title: "Drive to",
                    icon: Icons.drive_eta_rounded,
                    onClick: () {}
                  ),
                  CircledButton(
                    title: "Call",
                    icon: Icons.call,
                    onClick: () => RouteNavigator.callNumber(widget.shop.phone)
                  ),
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
                  CategoryImage(image: widget.shop.image, height: 50, width: 50),
                  const SizedBox(height: 10),
                  Expanded(child: _buildStatus(context))
                ],
              ),
            ),
            DefaultTabController(
              length: tabs.length,
              child: TabBar(
                onTap: (index) => updateTab(index),
                indicatorColor: Theme.of(context).primaryColor,
                overlayColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                  return Theme.of(context).splashColor;
                }),
                tabs: tabs.map((tab) {
                  return Tab(
                    child: SText(
                      text: tab,
                      color: Theme.of(context).primaryColor,
                      size: Sizing.font(14),
                    )
                  );
                }).toList()
              )
            ),
            IndexedStack(
              index: current,
              children: [
                ShopViewWeekdays(weekdays: widget.shop.weekdays),
                ShopViewServices(services: widget.shop.services),
                ShopViewProfile(shop: widget.shop),
              ]
            )
          ],
        ),
      )
    );
  }

  Widget _buildStatus(BuildContext context) {
    if(widget.shop.current != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SText(
                  text: widget.shop.current!.day,
                  color: Theme.of(context).primaryColor,
                  size: Sizing.font(14),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SText.center(
                      text: widget.shop.current!.opening,
                      size: Sizing.font(11),
                      color: Theme.of(context).primaryColor
                    ),
                    const SizedBox(width: 5),
                    SText.center(
                      text: "-",
                      size: Sizing.font(11),
                      color: Theme.of(context).primaryColor
                    ),
                    const SizedBox(width: 5),
                    SText.center(
                      text: widget.shop.current!.closing,
                      size: Sizing.font(11),
                      color: Theme.of(context).primaryColor
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(width: 10),
          Switcher(onChanged: (value) { }, value: widget.shop.open)
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Switcher(onChanged: (value) { }, value: widget.shop.open)
        ],
      );
    }
  }
}