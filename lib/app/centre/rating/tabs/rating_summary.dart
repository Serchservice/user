import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class RatingSummary extends StatelessWidget {
  const RatingSummary({super.key, required this.controller});

  final RatingController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(controller.state.isFetching.value) {
        return Padding(
          padding: EdgeInsets.all(Sizing.space(10)),
          child: LoadingShimmer(
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    decoration: BoxDecoration(
                      color: CommonColors.shimmerHigh,
                      borderRadius: BorderRadius.circular(16)
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    decoration: BoxDecoration(
                      color: CommonColors.shimmerHigh,
                      borderRadius: BorderRadius.circular(6)
                    ),
                  ),
                  const SizedBox(height: 10),
                  AspectRatio(
                    aspectRatio: 1.23,
                    child: Container(
                      padding: EdgeInsets.all(Sizing.space(9)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: CommonColors.shimmerHigh
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    itemCount: 4,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(bottom: Sizing.space(10)),
                        height: 90,
                        decoration: BoxDecoration(
                          color: CommonColors.shimmerHigh,
                          borderRadius: BorderRadius.circular(6)
                        ),
                      );
                    }
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      color: CommonColors.shimmerHigh,
                      borderRadius: BorderRadius.circular(16)
                    ),
                  ),
                ],
              ),
            )
          ),
        );
      } else {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(controller.state.showRating.value)...[
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(Sizing.space(12)),
                  margin: EdgeInsets.all(Sizing.space(10)),
                  decoration: BoxDecoration(
                    color: CommonColors.yellow,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Row(
                    children: [
                      const Expanded(child: SText(text: "NOTE: Ratings are summarized on a three-month basis. Be advised.")),
                      IconButton(
                        onPressed: () => controller.stopShowingRating(),
                        icon: const Icon(
                          Icons.close,
                          color: CommonColors.lightTheme,
                        )
                      )
                    ],
                  )
                )
              ],
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizing.space(12)),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RatingIcon(rating: controller.home.state.rating.value),
                        Icon(
                          Icons.swap_vert_circle_rounded,
                          size: Sizing.space(16),
                          color: controller.home.state.rating.value >= 3.0
                            ? CommonColors.green
                            : controller.home.state.rating.value >= 1.5 ? CommonColors.yellow
                            : CommonColors.error
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizing.space(12)),
                child: AspectRatio(
                  aspectRatio: 1.23,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF0D0B17),
                          Color(0xFF0A0A0A),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const SizedBox(height: 30),
                            SText.center(
                              text: 'Rating Summary',
                              color: const Color(0xff827daa),
                              size: Sizing.font(16)
                            ),
                            const SizedBox(height: 4),
                            SText.center(
                              text: 'Monthly Summary',
                              color: CommonColors.lightTheme,
                              size: Sizing.font(26),
                              weight: FontWeight.bold
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: Sizing.space(16), left: Sizing.space(6)),
                                child: BarChart(
                                  BarChartData(
                                    maxY: 5.0,
                                    barGroups: controller.state.bars,
                                    barTouchData: BarTouchData(),
                                    titlesData: FlTitlesData(
                                      show: true,
                                      rightTitles: const AxisTitles(
                                        sideTitles: SideTitles(showTitles: false),
                                      ),
                                      topTitles: const AxisTitles(
                                        sideTitles: SideTitles(showTitles: false),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (value, meta) {
                                            return bottomTitles(value, meta, controller.state.months);
                                          },
                                          reservedSize: 42,
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 28,
                                          interval: 1,
                                          getTitlesWidget: leftTitle,
                                        ),
                                      ),
                                    ),
                                    borderData: borderData,
                                    gridData: gridData,
                                  )
                                )
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SText(
                  text: "Recent Reviews",
                  color: Theme.of(context).primaryColor,
                  size: Sizing.font(16),
                ),
              ),
              const SizedBox(height: 10),
              if(controller.state.recent.isNotEmpty) ...[
                ...controller.state.recent.map((recent) => RatingReview(review: recent))
              ],
              if(controller.state.recent.isEmpty) ...[
                Center(
                  child: SText.center(
                    text: "You do not have any rating",
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
              const SizedBox(height: 50),
              Container(
                padding: EdgeInsets.all(Sizing.space(9)),
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SText.center(
                      text: '${controller.state.current.value.month} Review',
                      color: Theme.of(context).primaryColor,
                      size: Sizing.font(16),
                      weight: FontWeight.bold
                    ),
                    const SizedBox(height: 10),
                    SummaryBox(title: "Average Rating", value: "${controller.state.current.value.average}"),
                    const SizedBox(height: 5),
                    SummaryBox(title: "Total Rating", value: "${controller.state.current.value.total}"),
                    const SizedBox(height: 5),
                    SummaryBox(title: "Good Rating", value: "${controller.state.current.value.good}"),
                    const SizedBox(height: 5),
                    SummaryBox(title: "Bad Rating", value: "${controller.state.current.value.bad}"),
                    const SizedBox(height: 10),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF0D0B17),
                            Color(0xFF0A0A0A),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SText(
                          text: "Serch reserves the right to suspend your account if your account is consistently low.",
                          color: CommonColors.lightTheme,
                          size: Sizing.font(12)
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]
          )
        );
      }
    });
  }

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: const Border(
      bottom: BorderSide(
        color: Color(0xFF292929),
        width: 4
      ),
      left: BorderSide(
        color: Colors.transparent
      ),
      right: BorderSide(
        color: Colors.transparent
      ),
      top: BorderSide(
        color: Colors.transparent
      ),
    ),
  );

  Widget leftTitle(double value, TitleMeta meta) {
    final style = TextStyle(
      color: const Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: Sizing.font(14),
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1.0';
        break;
      case 2:
        text = '2.0';
        break;
      case 3:
        text = '3.0';
        break;
      case 4:
        text = '4.0';
        break;
      case 5:
        text = '5.0';
        break;
      default: return Container();
    }

    return Text(
      text,
      style: style,
      textAlign: TextAlign.center
    );
  }

  SideTitles get leftTitles => SideTitles(
    getTitlesWidget: leftTitle,
    showTitles: true,
    interval: 1,
    reservedSize: Sizing.font(40),
  );

  Widget bottomTitles(double value, TitleMeta meta, List<String> titles) {
    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff72719b),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }
}

class SummaryBox extends StatelessWidget {
  final String title;
  final String value;
  const SummaryBox({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SText(
          text: title,
          color: Theme.of(context).primaryColor,
          size: Sizing.font(14),
        ),
        const SizedBox(width: 10),
        const Expanded(child: Divider()),
        const SizedBox(width: 10),
        SText(
          text: value,
          color: Theme.of(context).primaryColor,
          size: Sizing.font(14),
          weight: FontWeight.bold
        )
      ]
    );
  }
}