import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class SearchResultItem extends StatelessWidget {
  final Active? active;
  final SearchShopResponse? shop;
  final bool isBest;
  final SearchResultController controller;

  const SearchResultItem({super.key, this.active, this.shop, this.isBest = false, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String category = controller.state.search.value.category?.category
          ?? controller.state.search.value.special?.category
          ?? "";
      Address pickup = Address(
        longitude: controller.state.search.value.address.longitude,
        latitude: controller.state.search.value.address.latitude,
        place: controller.state.search.value.address.place
      );
      String distance = shop != null
        ? LocationUtils.instance.getDistanceInKm(
          pickupLatitude: pickup.latitude,
          pickupLongitude: pickup.longitude,
          destinationLatitude: shop!.shop.latitude,
          destinationLongitude: shop!.shop.longitude
        )
        : active != null ? active!.distanceInKm : "";

      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Material(
            color: isBest ? CommonColors.green : CommonUtility.lightenColor(Theme.of(context).colorScheme.surface, 6),
            child: InkWell(
              onTap: () => SearchResultItemSheet.open(
                pickup: pickup,
                category: category,
                active: active,
                shop: shop,
                isBest: isBest
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _build(context, distance),
                    _buildRecommended(context),
                  ],
                ),
              )
            )
          ),
        ),
      );
    });
  }

  Widget _buildRecommended(BuildContext context) {
    if(shop != null) {
      if(!shop!.isGoogle) {
        return Container(
          padding: EdgeInsets.all(4),
          margin: EdgeInsets.only(left: 6, top: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: CommonColors.success)
          ),
          child: SText(text: "RECOMMENDED", size: Sizing.font(12), color: CommonColors.success),
        );
      }
    }

    return SizedBox.shrink();
  }

  Widget _build(BuildContext context, String distance) {
    if(active != null) {
      return _buildContent(
        context: context,
        image: active!.avatar,
        name: active!.name,
        distance: distance,
        rating: active!.rating,
        category: active!.status
      );
    } else if(shop != null) {
      return _buildContent(
        context: context,
        image: shop!.shop.logo,
        name: shop!.shop.name,
        distance: distance,
        rating: shop!.shop.rating,
        category: shop!.shop.category
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildContent({
    required BuildContext context,
    required String image,
    required String name,
    required String distance,
    required double rating,
    required String category
  }) {
    Color textColor = isBest ? CommonColors.lightTheme : Theme.of(context).primaryColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Avatar.small(avatar: image),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SText(
                      text: CommonUtility.capitalizeWords(name),
                      size: Sizing.font(14),
                      color: textColor,
                      weight: FontWeight.bold,
                      flow: TextOverflow.ellipsis
                    ),
                  ),
                  const SizedBox(width: 10),
                  SText(text: distance, size: Sizing.font(12), color: textColor),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: SText(
                      text: CommonUtility.capitalizeWords(category),
                      size: Sizing.font(11),
                      color: isBest ? CommonColors.lightTheme2 : Theme.of(context).primaryColorLight,
                      flow: TextOverflow.ellipsis
                    ),
                  ),
                  const SizedBox(width: 10),
                  RatingIcon(
                    rating: rating,
                    iconSize: 14,
                    textSize: 10
                  ),
                ],
              ),
            ],
          )
        ),
      ],
    );
  }
}