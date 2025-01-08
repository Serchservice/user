import 'package:user/library.dart';
import 'package:flutter/material.dart';

class DashboardItem extends StatelessWidget {
  final ButtonView view;
  final double? width;

  const DashboardItem({super.key, required this.view, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Sizing.space(12)),
      width: width ?? MediaQuery.sizeOf(context).width,
      constraints: const BoxConstraints(maxHeight: 100),
      decoration: BoxDecoration(
        color: CommonColors.darkTheme2,
        borderRadius: BorderRadius.circular(16)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SText(
                text: view.body,
                size: Sizing.font(20),
                color: CommonColors.lightTheme,
                weight: FontWeight.bold,
              ),
              if(view.icon != Icons.copy) ...[
                Icon(view.icon, color: CommonColors.lightTheme, size: 25)
              ]
            ],
          ),
          const SizedBox(height: 14),
          if(view.path.isNotEmpty) ...[
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(view.path, width: 30),
                  const SizedBox(width: 6),
                  Expanded(
                    child: SText(
                      text: view.header,
                      size: Sizing.font(15),
                      color: CommonColors.lightTheme
                    ),
                  ),
                ],
              ),
            )
          ],
          if(view.path.isEmpty) ...[
            Expanded(
              child: SText(
                text: view.header,
                size: Sizing.font(15),
                color: CommonColors.lightTheme
              ),
            )
          ]
        ],
      )
    );
  }
}