import 'package:user/library.dart';
import 'package:flutter/material.dart';

class ShopView extends StatefulWidget {
  final SearchShopResponse response;
  final double longitude;
  final double latitude;

  const ShopView({required this.response, super.key, required this.longitude, required this.latitude});

  @override
  State<ShopView> createState() => _ShopViewState();

  static void open({required SearchShopResponse response, required double latitude, required double longitude}) {
    Navigate.bottomSheet(
      sheet: ShopView(response: response, latitude: latitude, longitude: longitude),
      route: "/dashboard/request/result/view?shop=${response.shop.id}"
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
                  Avatar.small(avatar: widget.response.shop.logo),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SText(
                          text: widget.response.shop.name,
                          color: Theme.of(context).primaryColor,
                          size: Sizing.font(16),
                          weight: FontWeight.bold,
                          flow: TextOverflow.ellipsis
                        ),
                        RatingIcon(rating: widget.response.shop.rating),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircledButton(
                    title: "Drive to",
                    asset: Media.mapRight,
                    onClick: () => NavigationOptionSheet.open(widget.response),
                    backgroundColor: Theme.of(context).textSelectionTheme.selectionColor,
                  ),
                  CircledButton(
                    title: "Call",
                    icon: Icons.call,
                    onClick: () => RouteNavigator.callNumber(widget.response.shop.phone),
                    backgroundColor: Theme.of(context).textSelectionTheme.selectionColor,
                  ),
                ],
              )
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.all(Sizing.space(16)),
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CategoryImage(image: widget.response.shop.image, height: 50, width: 50),
                  const SizedBox(width: 10),
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
                ShopViewWeekdays(weekdays: widget.response.shop.weekdays),
                ShopViewServices(services: widget.response.shop.services),
                ShopViewProfile(shop: widget.response.shop),
              ]
            )
          ],
        ),
      )
    );
  }

  Widget _buildStatus(BuildContext context) {
    if(widget.response.shop.current != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SText(
                  text: widget.response.shop.current!.day,
                  color: Theme.of(context).primaryColor,
                  size: Sizing.font(14),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SText.center(
                      text: widget.response.shop.current!.opening,
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
                      text: widget.response.shop.current!.closing,
                      size: Sizing.font(11),
                      color: Theme.of(context).primaryColor
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(width: 10),
          Switcher(onChanged: (value) { }, value: widget.response.shop.open)
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SText(
              text: widget.response.shop.open
                ? "This shop is currently open"
                : "This shop is currently closed",
              color: Theme.of(context).primaryColor,
              flow: TextOverflow.ellipsis,
              size: Sizing.font(14),
            ),
          ),
          const SizedBox(width: 10),
          Switcher(onChanged: (value) { }, value: widget.response.shop.open)
        ],
      );
    }
  }
}