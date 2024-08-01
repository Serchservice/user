import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class TripActiveFilterSheet extends StatefulWidget {
  final HomeController controller;
  const TripActiveFilterSheet({super.key, required this.controller});

  static void open({required HomeController controller}) => Navigate.bottomSheet(
      sheet: TripActiveFilterSheet(controller: controller),
      isScrollable: true,
      route: "/activity?active=active&current=trip&option=filter"
  );

  @override
  State<TripActiveFilterSheet> createState() => _TripActiveFilterSheetState();
}

class _TripActiveFilterSheetState extends State<TripActiveFilterSheet> {
  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(Sizing.space(2)),
              margin: EdgeInsets.all(Sizing.space(6)),
              alignment: Alignment.center,
              width: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(16)
              ),
            ),
          ),
          Center(
            child: SText.center(
              text: "Advanced trip filter",
              size: Sizing.font(16),
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor
            ),
          ),
          SText.center(
              text: "Filter by category",
              size: Sizing.font(14),
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor
          ),
          const SizedBox(height: 10),
          Obx(() => SearchFilter(
            list: widget.controller.activity.commons,
            selectedIndex: widget.controller.state.activeTripCategoryFilter.value,
            onSelect: (view) => widget.controller.activity.filterActiveTripsByCategory(view.index)
          )),
          const SizedBox(height: 30),
        ]
      )
    );
  }
}
