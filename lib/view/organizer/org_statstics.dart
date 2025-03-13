import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../componets/text_style.dart';
import '../../generated/assets.dart';
import '../../utills/appcolors.dart';

class OrgStatstics extends StatelessWidget {
  final int eventId;

  const OrgStatstics({
    required this.eventId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<BarChartGroupData> barGroups = [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: 150,
            color: Colors.black,
            width: 16,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 200,
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: 120,
            color: Colors.black,
            width: 16,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 180,
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
            toY: 90,
            color: Colors.black,
            width: 16,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 150,
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
        ],
        showingTooltipIndicators: [0],
      ),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              surfaceTintColor: Colors.black,
              backgroundColor: Colors.black,
              title: TextStyleHelper.CustomText(
                text: "Statistics",
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w600,
                fontSize: 20,
                fontFamily: Assets.fontsPoppinsBold,
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextStyleHelper.CustomText(
                            text: "Arijit singh in surat",
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: Assets.fontsPoppinsBold,
                          ),
                          SizedBox(height: 10),
                          FittedBox(
                            child: TextStyleHelper.CustomText(
                              text: "Track \nYour Events \nLive Data.",
                              color: AppColors.lightGrey,
                              fontWeight: FontWeight.w600,
                              fontSize: 40,
                              fontFamily: Assets.fontsPoppinsBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.yellow,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextStyleHelper.CustomText(
                            text: "\u{20B9}20000",
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 35,
                            fontFamily: Assets.fontsPoppinsBold,
                          ),
                          TextStyleHelper.CustomText(
                            text: "Total Sales",
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                            fontFamily: Assets.fontsPoppinsBold,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.red,
                    width: double.infinity,
                    height: 220,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 15,
                                    width: 15,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 10),
                                  TextStyleHelper.CustomText(
                                    text: "Booked Tickets",
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    fontFamily: Assets.fontsPoppinsBold,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              TextStyleHelper.CustomText(
                                text: '275,039',
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 35,
                                fontFamily: Assets.fontsPoppinsBold,
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    height: 15,
                                    width: 15,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10),
                                  TextStyleHelper.CustomText(
                                    text: "Available Tickets",
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    fontFamily: Assets.fontsPoppinsBold,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              TextStyleHelper.CustomText(
                                text: '20,000',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 35,
                                fontFamily: Assets.fontsPoppinsBold,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: FittedBox(
                              child: Container(
                                width: 150,
                                height: 100,
                                child: PieChart(
                                  PieChartData(
                                    sections: [
                                      PieChartSectionData(
                                        value: 75,
                                        color: Colors.black,
                                        radius: 40,
                                        showTitle: false,
                                      ),
                                      PieChartSectionData(
                                        value: 25,
                                        color: Colors.white,
                                        radius: 40,
                                        showTitle: false,
                                      ),
                                    ],
                                    centerSpaceRadius: 50,
                                    sectionsSpace: 0,
                                    startDegreeOffset: 270,
                                    pieTouchData: PieTouchData(enabled: false),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Color(0xFFD4F0C7),
                    width: double.infinity,
                    height: 330,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category-wise Booked Tickets',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: Assets.fontsPoppinsBold
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 250,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: 200,
                                barGroups: barGroups,
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      interval: 50,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      getTitlesWidget: (value, meta) {
                                        const categories = ['Diamond', 'Gold', 'Sliver'];
                                        return Text(
                                          categories[value.toInt()],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                gridData: FlGridData(show: false),
                                borderData: FlBorderData(show: false),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}