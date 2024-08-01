import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ScheduleHistoryFilterSheet extends StatefulWidget {
  final HomeController controller;
  const ScheduleHistoryFilterSheet({super.key, required this.controller});

  static void open({required HomeController controller}) => Navigate.bottomSheet(
      sheet: ScheduleHistoryFilterSheet(controller: controller),
      isScrollable: true,
      route: "/activity?active=history&current=schedule&option=filter"
  );

  @override
  State<ScheduleHistoryFilterSheet> createState() => _ScheduleHistoryFilterSheetState();
}

class _ScheduleHistoryFilterSheetState extends State<ScheduleHistoryFilterSheet> {
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
              text: "Advanced schedule filter",
              size: Sizing.font(16),
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor
            ),
          ),
          const SizedBox(height: 30),
          SText.center(
              text: "Filter by status",
              size: Sizing.font(14),
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor
          ),
          const SizedBox(height: 10),
          Obx(() => SearchFilter(
            list: widget.controller.activity.scheduleHistory,
            selectedIndex: widget.controller.state.historyScheduleFilter.value,
            onSelect: (view) => widget.controller.activity.filterScheduleHistoryByStatus(view.index)
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
              selectedIndex: widget.controller.state.historyScheduleCategoryFilter.value,
              onSelect: (view) => widget.controller.activity.filterScheduleHistoryByCategory(view.index)
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
                  if(widget.controller.state.selectedScheduleHistoryFilterDate.value != DateTime(2009)) {
                    return SText(
                      text: CommonUtility.formatDay(
                        widget.controller.state.selectedScheduleHistoryFilterDate.value,
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
                      onTap: () => widget.controller.activity.pickDate(isSchedule: true, context: context)
                  ),
                  const SizedBox(width: 10),
                  _buildButton(context: context, text: "Clear", onTap: () => widget.controller.activity.clearFilter(true)),
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
