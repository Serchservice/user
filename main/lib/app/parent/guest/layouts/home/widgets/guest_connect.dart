import 'package:flutter/material.dart';
import 'package:user/library.dart';

class GuestConnect extends StatelessWidget {
  final SharedLinkData data;

  const GuestConnect({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: CommonColors.green,
        child: InkWell(
          onTap: () => RequestEntryLayout.request(provider: data.provider),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 4,
                    children: [
                      SText(
                        text: "You're connected to ${data.provider.name} who is ${CommonUtility.textWithAorAn(data.provider.category)}",
                        size: Sizing.space(14),
                        weight: FontWeight.w700,
                        color: CommonColors.lightTheme
                      ),
                      SText(
                        text: "If you're not currently on a trip with this provider, tap here to connect.",
                        size: Sizing.space(12),
                        color: CommonColors.lightTheme
                      ),
                    ],
                  ),
                ),
              ),
              CategoryImage(image: data.image, width: 60)
            ],
          ),
        ),
      ),
    );
  }
}