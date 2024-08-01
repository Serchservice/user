import 'package:user/library.dart';
import 'package:flutter/material.dart';

class ShopViewServices extends StatelessWidget {
  final List<ShopService> services;
  const ShopViewServices({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        runAlignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: services.map((service) => Container(
          padding: EdgeInsets.all(Sizing.space(6)),
          margin: EdgeInsets.only(bottom: Sizing.space(6)),
          decoration: BoxDecoration(
              color: CommonColors.darkTheme2,
              borderRadius: BorderRadius.circular(16)
          ),
          child: SText(
            text: service.service,
            color: CommonColors.lightTheme,
          ),
        )).toList(),
      ),
    );
  }
}