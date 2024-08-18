import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class NavigationOptionSheet extends StatelessWidget {
  final SearchShopResponse shop;
  const NavigationOptionSheet({super.key, required this.shop});

  static void open(SearchShopResponse shop) => Navigate.bottomSheet(
    sheet: NavigationOptionSheet(shop: shop),
    route: "/drive?to=${shop.shop.address}&latitude=${shop.shop.latitude}&longitude=${shop.shop.longitude}",
    background: Colors.transparent,
    isScrollable: true
  );

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      child: GetX<NavigationOptionSheetController>(
        init: NavigationOptionSheetController(shop: shop),
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(Sizing.space(2)),
                    margin: EdgeInsets.all(Sizing.space(6)),
                    width: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(16)
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: SText(
                    text: "Choose the navigation that works for you",
                    size: Sizing.font(16),
                    weight: FontWeight.bold,
                    color: Theme.of(context).primaryColor
                  ),
                ),
                const SizedBox(height: 20),
                ...controller.options(context).map((button) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: controller.options(context).length - 1 != button.index ? 8 : 0),
                    child: NavigatorButton(
                      header: button.header,
                      detail: button.body,
                      prefixIcon: button.icon,
                      iconColor: button.color,
                      headerSize: 14,
                      onPressed: () => controller.act(button),
                    ),
                  );
                })
              ],
            )
          );
        }
      )
    );
  }
}