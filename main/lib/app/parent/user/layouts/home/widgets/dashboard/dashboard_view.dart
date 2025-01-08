import 'package:user/library.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  final Dashboard dashboard;
  final bool isLoading;

  const DashboardView({super.key, required this.dashboard, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    ResponsiveBreakpoint responsive = ResponsiveBreakpoint.init(context);
    double width = MediaQuery.sizeOf(context).width;
    double desktopWidth = width / 2.04;

    if(isLoading) {
      if(responsive.isDesktop) {
        return Wrap(
          spacing: 6,
          runSpacing: 6,
          children: CommonUtility.generateList(4).map((_) => _loading(desktopWidth)).toList(),
        );
      } else {
        return LoadingShimmer(
          content: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) => SizedBox(height: 6),
            itemCount: 4,
            itemBuilder: (context, index) => _loading(width),
          ),
        );
      }
    } else {
      List<ButtonView> views = [
        ButtonView(header: "Total Trips", body: dashboard.trip, icon: Icons.trending_up_rounded, path: ""),
        ButtonView(header: "Total Shared Trips", body: dashboard.shared, icon: Icons.share_location_rounded, path: ""),
        ButtonView(header: "Average Rating", body: dashboard.rating, icon: Icons.stars_outlined, path: ""),
        ButtonView(header: "Total Schedule", body: dashboard.schedule, icon: Icons.calendar_month_outlined, path: ""),
        ButtonView(header: "Total Earnings", body: dashboard.earning, path: Media.wallet)
      ];

      if(responsive.isDesktop) {
        return Wrap(
          spacing: 6,
          runSpacing: 6,
          children: views.map((view) {
            bool isLast = views.indexOf(view) == views.length - 1;

            return DashboardItem(view: view, width: isLast ? null : desktopWidth);
          }).toList(),
        );
      } else {
        return ListView.separated(
          itemCount: views.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 6),
          itemBuilder: (context, index) => DashboardItem(view: views.elementAt(index))
        );
      }
    }
  }

  Widget _loading(double width) {
    return Container(
      width: width,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: CommonColors.shimmerHigh
      ),
    );
  }
}