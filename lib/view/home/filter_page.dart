import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/filter_cont.dart';
import '../../utills/appcolors.dart';

class FilterPage extends StatelessWidget {
  FilterPage({super.key});

  final FilterController filterController = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 60,
              automaticallyImplyLeading: false,
              surfaceTintColor: Colors.black,
              backgroundColor: Colors.black,
              elevation: 0,
              pinned: true,
              title: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: 45,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.arrow_back, color: AppColors.whiteColor),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          onTap: () {},
                          cursorColor: AppColors.whiteColor,
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
                            hintText: "Search events",
                            hintStyle: TextStyle(color: Colors.grey, fontFamily: 'regular', fontSize: 14),
                            filled: true,
                            fillColor: AppColors.greyColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

                SliverAppBar(
                  automaticallyImplyLeading: false,
                  surfaceTintColor: Colors.black,
                  backgroundColor: Colors.black,
                  elevation: 0,
                  pinned: true,
                  title: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Obx(() {
                        return Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: filterController.selectedFilters.keys.map((filterName) {
                            return FilterChip(
                              checkmarkColor: Colors.black,
                              label: Text(
                                filterName,
                                style: TextStyle(color: filterController.selectedFilters[filterName]! ? Colors.black : Colors.white),
                              ),
                              selected: filterController.selectedFilters[filterName]!,
                              onSelected: (bool selected) {
                                filterController.selectedFilters[filterName] = selected;
                              },
                              backgroundColor: Colors.black,
                              selectedColor: AppColors.whiteColor,
                            );
                          }).toList(),
                        );
                      }),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
