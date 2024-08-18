import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ActiveResultView extends StatelessWidget {
  final Active? active;
  final SearchShopResponse? shop;
  final List<ButtonView> buttons;
  final Function(ButtonView, Active?, SearchShopResponse?) actOnView;
  final bool isBest;
  final double latitude;
  final double longitude;

  const ActiveResultView({
    super.key,
    this.active,
    this.shop,
    required this.buttons,
    this.isBest = false,
    required this.latitude,
    required this.longitude,
    required this.actOnView
  }) : assert((shop == null && active != null) || (shop != null && active == null));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: isBest ? CommonColors.green : Theme.of(context).colorScheme.surface,
          child: InkWell(
            onTap: shop != null
              ? () => ShopView.open(response: shop!, latitude: latitude, longitude: longitude)
              : active != null
                ? () => ActiveProviderView.open(active: active!)
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(active != null) ...[
                    _buildContent(
                      context: context,
                      image: active!.avatar,
                      name: active!.name,
                      distance: active!.distanceInKm,
                      rating: active!.rating,
                      category: active!.status
                    )
                  ] else if(shop != null) ...[
                    _buildContent(
                      context: context,
                      image: shop!.shop.logo,
                      name: shop!.shop.name,
                      distance: shop!.distanceInKm,
                      rating: shop!.shop.rating,
                      category: shop!.shop.category
                    )
                  ],
                  const SizedBox(height: 8),
                  _buildButtons(
                    context: context,
                    buttons: buttons,
                    onClick: (view) => actOnView.call(view, active, shop)
                  ),
                ],
              ),
            )
          )
        ),
      ),
    );
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
                      text: name,
                      size: Sizing.font(14),
                      color: textColor,
                      flow: TextOverflow.ellipsis
                    ),
                  ),
                  const SizedBox(width: 10),
                  SText(
                      text: distance,
                      size: Sizing.font(12),
                      color: textColor
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: SText(
                      text: category,
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

  Widget _buildButtons({required BuildContext context, required List<ButtonView> buttons, required Function(ButtonView) onClick}) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: buttons.length, crossAxisSpacing: 4, mainAxisExtent: 35,),
      shrinkWrap: true,
      itemCount: buttons.length,
      itemBuilder: (context, index) {
        ButtonView view = buttons[index];
        return TextButton.icon(
          onPressed: () => onClick.call(view),
          icon: Icon(view.icon, size: 16, color: Theme.of(context).primaryColor),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              return Theme.of(context).appBarTheme.backgroundColor;
            }),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              return CommonColors.shimmerBase.withOpacity(.48);
            }),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            padding: WidgetStatePropertyAll(EdgeInsets.all(Sizing.space(4)))
          ),
          label: SText(
            text: view.header,
            size: Sizing.font(12),
            color: Theme.of(context).primaryColor
          )
        );
      },
    );
  }
}