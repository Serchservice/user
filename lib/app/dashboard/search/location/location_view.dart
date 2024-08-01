import 'package:flutter/material.dart';
import 'package:user/library.dart';

class LocationView extends StatelessWidget {
  final Address address;
  final Function(Address)? onSelect;
  final bool withPadding;
  final double fontSize;

  const LocationView({
    super.key,
    required this.address,
    this.onSelect,
    this.withPadding = false,
    this.fontSize = 12
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelect?.call(address),
        child: Padding(
          padding: withPadding ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SText(
                      text: address.place,
                      size: Sizing.font(fontSize),
                      color: Theme.of(context).primaryColor,
                      lines: 2,
                      flow: TextOverflow.ellipsis
                    ),
                    const SizedBox(height: 4),
                    SText(
                      text: address.country,
                      size: Sizing.font(12),
                      color: Theme.of(context).primaryColorLight
                    ),
                  ],
                )
              ),
              const CategoryImage(image: Media.location, width: 60, height: 60)
            ],
          ),
        ),
      ),
    );
  }
}