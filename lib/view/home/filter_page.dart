import 'package:eventapp/controller/filter_cont.dart';
import 'package:eventapp/generated/assets.dart';
import 'package:eventapp/view/home/dashboard_page.dart';
import 'package:eventapp/view/home/event_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../componets/CardWidget.dart';
import '../../componets/searchWidget.dart';
import '../../controller/home_cont.dart';
import '../../utills/appcolors.dart';

class FilterPage extends StatelessWidget {
  FilterPage({super.key});
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            // 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.offAll(DashboardPage()),
                    child: Icon(Icons.arrow_back, color: AppColors.whiteColor),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      cursorColor: AppColors.whiteColor,
                      onChanged: (value) => homeController.updateSearchQuery(value),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.whiteColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.whiteColor),
                        ),
                        prefixIcon: Icon(Icons.search, color: AppColors.whiteColor, size: 20),
                        hintText: "Search by name, date, artist...",
                        hintStyle: TextStyle(color: AppColors.lightGrey, fontFamily: Assets.fontsPoppinsRegular, fontSize: 14),
                        filled: true,
                        fillColor: AppColors.greyColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Obx(() {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: homeController.selectedFilters.keys.map((filterName) {
                      return FilterChip(
                        checkmarkColor: Colors.black,
                        label: Text(
                          filterName,
                          style: TextStyle(
                            color: homeController.selectedFilters[filterName]!
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                        selected: homeController.selectedFilters[filterName]!,
                        onSelected: (bool selected) {
                          homeController.updateFilter(filterName, selected);
                        },
                        backgroundColor: Colors.black,
                        selectedColor: AppColors.whiteColor,
                      );
                    }).toList(),
                  ),
                ),
              );
            }),


            Expanded(
              child: Obx(() {
                if (homeController.filteredEvents.isEmpty) {
                  return Center(
                    child: Text(
                      "No events found",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                return GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 320,
                  ),
                  itemCount: homeController.filteredEvents.length,
                  itemBuilder: (context, index) {
                    return Searchwidget(index: index);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

/* import 'package:eventapp/componets/CardWidget.dart';
import 'package:eventapp/controller/home_cont.dart';
import 'package:eventapp/view/home/dashboard_page.dart';
import 'package:eventapp/view/home/event_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utills/appcolors.dart';

class FilterPage extends StatelessWidget {
  FilterPage({super.key});
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            // 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.offAll(DashboardPage()),
                    child: Icon(Icons.arrow_back, color: AppColors.whiteColor),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      cursorColor: AppColors.whiteColor,
                      onChanged: (value) => homeController.updateSearchQuery(value),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.whiteColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.whiteColor),
                        ),
                        prefixIcon: Icon(Icons.search, color: AppColors.whiteColor, size: 20),
                        hintText: "Search by name, date, artist...",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        filled: true,
                        fillColor: AppColors.greyColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Obx(() {
                if (homeController.filteredEvents.isEmpty) {
                  return Center(
                    child: Text(
                      "No events found",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                return GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 320,
                  ),
                  itemCount: homeController.filteredEvents.length,
                  itemBuilder: (context, index) {
                    return Cardwidget(index: index);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
*/
