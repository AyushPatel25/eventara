import 'package:eventapp/controller/filter_cont.dart';
import 'package:eventapp/generated/assets.dart';
import 'package:eventapp/view/home/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../componets/searchWidget.dart';
import '../../utills/appcolors.dart';

class FilterPage extends StatelessWidget {
  FilterPage({super.key});
  final FilterController filterController = Get.put(FilterController());

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
                      onChanged: (value) => filterController.updateSearchQuery(value),
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

            // 🏷️ Category Filters
            Obx(() {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: filterController.selectedFilters.keys.map((filterName) {
                      return FilterChip(
                        checkmarkColor: Colors.black,
                        label: Text(
                          filterName,
                          style: TextStyle(
                            color: filterController.selectedFilters[filterName]!
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                        selected: filterController.selectedFilters[filterName]!,
                        onSelected: (bool selected) {
                          filterController.updateFilter(filterName, selected);
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
                if (filterController.filteredEvents.isEmpty) {
                  return Center(
                    child: Text(
                      "Search or select a category to see events",
                      style: TextStyle(color: AppColors.whiteColor, fontFamily: Assets.fontsPoppinsRegular),
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
                  itemCount: filterController.filteredEvents.length,
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
