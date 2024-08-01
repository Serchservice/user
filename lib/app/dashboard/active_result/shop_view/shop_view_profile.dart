import 'package:user/library.dart';
import 'package:flutter/material.dart';

class ShopViewProfile extends StatelessWidget {
  final Shop shop;
  const ShopViewProfile({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Field(
            noEnabledColor: true,
            enabled: false,
            needLabel: true,
            labelColor: Theme.of(context).primaryColor,
            hintText: "Address",
            controller: TextEditingController(text: shop.address),
          ),
        ],
      ),
    );
  }
}