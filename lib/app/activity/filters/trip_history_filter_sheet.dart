import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class TripHistoryFilterSheet extends StatefulWidget {
  final HomeController controller;
  const TripHistoryFilterSheet({super.key, required this.controller});

  static void open({required HomeController controller}) => Navigate.bottomSheet(
      sheet: TripHistoryFilterSheet(controller: controller),
      isScrollable: true,
      route: "/activity?active=history&current=trip&option=filter"
  );

  @override
  State<TripHistoryFilterSheet> createState() => _TripHistoryFilterSheetState();
}

class _TripHistoryFilterSheetState extends State<TripHistoryFilterSheet> {
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
          const SizedBox(height: 30),
          SText.center(
              text: "Filter by sharing",
              size: Sizing.font(14),
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor
          ),
          const SizedBox(height: 10),
          Obx(() => SearchFilter(
            list: widget.controller.activity.share,
            selectedIndex: widget.controller.state.historyTripShareFilter.value,
            onSelect: (view) => widget.controller.activity.filterTripHistoryBySharing(view.index)
          )),
          const SizedBox(height: 30),
          SText.center(
              text: "Filter by category",
              size: Sizing.font(14),
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor
          ),
          const SizedBox(height: 10),
          Obx(() => SearchFilter(
              list: widget.controller.activity.commons,
              selectedIndex: widget.controller.state.historyTripCategoryFilter.value,
              onSelect: (view) => widget.controller.activity.filterTripHistoryByCategory(view.index)
          )),
          const SizedBox(height: 30),
          SText.center(
              text: "Filter by date",
              size: Sizing.font(14),
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Obx(() {
                  if(widget.controller.state.selectedTripHistoryFilterDate.value != DateTime(2009)) {
                    return SText(
                      text: CommonUtility.formatDay(
                        widget.controller.state.selectedTripHistoryFilterDate.value,
                        showTime: false
                      ),
                      size: Sizing.font(14),
                      color: Theme.of(context).primaryColor
                    );
                  } else {
                    return Container();
                  }
                }),
              ),
              const SizedBox(width: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButton(
                    context: context,
                    text: "Pick date",
                    onTap: () => widget.controller.activity.pickDate(isSchedule: false, context: context)
                  ),
                  const SizedBox(width: 10),
                  _buildButton(context: context, text: "Clear", onTap: () => widget.controller.activity.clearFilter(false)),
                ],
              )
            ],
          )
        ]
      )
    );
  }

  Widget _buildButton({required BuildContext context, VoidCallback? onTap, required String text}) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          return Database.preference.isLightTheme ? CommonColors.lightTheme : CommonColors.darkTheme;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          return Database.preference.isLightTheme ? CommonColors.hinted : CommonColors.shimmerBase.withOpacity(.48);
        }),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
            vertical: Sizing.space(4),
            horizontal: Sizing.space(6)
        ))
      ),
      child: SText(
        text: text,
        size: Sizing.font(11),
        color: Database.preference.isLightTheme ? CommonColors.darkTheme : CommonColors.lightTheme,
      )
    );
  }
}
