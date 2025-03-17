import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../componets/text_style.dart';
import '../../controller/org_stat_cont.dart';
import '../../generated/assets.dart';
import '../../utills/appcolors.dart';


class OrgStatistics extends StatelessWidget {
  final int eventId;

  const OrgStatistics({
    required this.eventId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize and fetch data with the statistics controller
    final StatisticsController statsController = Get.put(StatisticsController());
    statsController.fetchEventStatistics(eventId);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Obx(() {
          // Show loading indicator while data is being fetched
          if (statsController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.whiteColor,
              ),
            );
          }

          // Get category names for bar chart
          List<String> categoryNames = statsController.getCategoryNames();

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                surfaceTintColor: Colors.black,
                backgroundColor: Colors.black,
                title: TextStyleHelper.CustomText(
                  text: "Statistics",
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
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
                              text: "Event ID: $eventId",
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
                    // Total Sales Container
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
                              text: "\u{20B9}${statsController.totalIncome.value.toStringAsFixed(0)}",
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
                    // Tickets Container
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
                                  text: '${statsController.bookedSeats.value}',
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
                                  text: '${statsController.availableSeats.value}',
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
                                          value: statsController.bookedSeats.value.toDouble(),
                                          color: Colors.black,
                                          radius: 40,
                                          showTitle: false,
                                        ),
                                        PieChartSectionData(
                                          value: statsController.availableSeats.value.toDouble(),
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
                    // Bar Chart Container
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
                            SizedBox(height: 15),
                            Container(
                              height: 250,
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: 100, // 100% is the maximum
                                  barGroups: statsController.getCategoryBarData(),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        interval: 25, // Show 0, 25, 50, 75, 100
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            '${value.toInt()}%',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 11,
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
                                          int index = value.toInt();
                                          if (index >= 0 && index < categoryNames.length) {
                                            return Text(
                                              categoryNames[index],
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            );
                                          }
                                          return Text("");
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
          );
        }),
      ),
    );
  }
}