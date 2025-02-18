// import 'package:eventapp/view/home/dashboard_page.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../componets/searchWidget.dart';
// import '../../controller/filter_cont.dart';
// import '../../generated/assets.dart';
// import '../../utills/appcolors.dart';
//
// class FilterPage extends StatelessWidget {
//   FilterPage({super.key});
//
//   final FilterController filterController = Get.put(FilterController());
//   final TextEditingController searchController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: CustomScrollView(
//             slivers: [
//               SliverAppBar(
//                 automaticallyImplyLeading: false,
//                 surfaceTintColor: Colors.black,
//                 backgroundColor: Colors.black,
//                 elevation: 0,
//                 pinned: true,
//                 title: Obx(() {
//                   return SizedBox(
//                     height: 43,
//                     child: TextField(
//                       controller: searchController,
//                       cursorColor: AppColors.whiteColor,
//                       onChanged: (value) =>
//                           filterController.updateSearchQuery(value),
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 10, horizontal: 10),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: AppColors.whiteColor),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: AppColors.whiteColor),
//                         ),
//                         prefixIcon: IconButton(
//                           onPressed: () {
//                             Get.offAll(DashboardPage());
//                           },
//                           icon: Icon(
//                               Icons.arrow_back, color: AppColors.whiteColor),
//                         ),
//                         hintText: "Search by name, date, artist...",
//                         hintStyle: TextStyle(
//                           color: AppColors.lightGrey,
//                           fontFamily: Assets.fontsPoppinsRegular,
//                           fontSize: 14,
//                         ),
//                         filled: true,
//                         fillColor: AppColors.greyColor,
//                       ),
//                     ),
//                   );
//                 }
//                 ),
//               ),
//
//               SliverAppBar(
//                 automaticallyImplyLeading: false,
//                 surfaceTintColor: Colors.black,
//                 backgroundColor: Colors.black,
//                 elevation: 0,
//                 pinned: true,
//                 title: Obx(() {
//                   return SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Wrap(
//                       spacing: 10,
//                       runSpacing: 10,
//                       children: filterController.selectedFilters.keys.map((filterName) {
//                         return SizedBox(
//                           height: 43,
//                           child: FilterChip(
//                             checkmarkColor: Colors.black,
//                             label: Text(
//                               filterName,
//                               style: TextStyle(
//                                 color: filterController.selectedFilters[filterName]!
//                                     ? Colors.black
//                                     : AppColors.whiteColor,
//                               ),
//                             ),
//                             selected: filterController.selectedFilters[filterName]!,
//                             onSelected: (bool selected) {
//                               filterController.updateFilter(filterName, selected);
//                             },
//                             backgroundColor: Colors.black,
//                             selectedColor: AppColors.whiteColor,
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   );
//                 }),
//               ),
//
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: EdgeInsets.only(top: 20, bottom: 10),
//                   child: Obx(() {
//                     bool noSearchQuery = searchController.text.isEmpty;
//                     bool noFiltersSelected = !filterController.selectedFilters.values.contains(true);
//
//                     if (noSearchQuery && noFiltersSelected) {
//                       return Center(
//                         child: Text(
//                           "Search or select a category to see events",
//                           style: TextStyle(color: AppColors.whiteColor, fontFamily: 'regular'),
//                         ),
//                       );
//                     }
//
//                     if (filterController.filteredEvents.isEmpty) {
//                       return Center(
//                         child: Text(
//                           "No event data found!",
//                           style: TextStyle(color: AppColors.whiteColor, fontFamily: 'regular'),
//                         ),
//                       );
//                     }
//
//                     return SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.7,
//                       child: GridView.builder(
//                         padding: EdgeInsets.all(10),
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 1,
//                           mainAxisSpacing: 16,
//                           mainAxisExtent: 320,
//                         ),
//                         itemCount: filterController.filteredEvents.length,
//                         itemBuilder: (context, index) {
//                           return Searchwidget(index: index);
//                         },
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:eventapp/componets/button.dart';
import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/controller/filter_cont.dart';
import 'package:eventapp/generated/assets.dart';
import 'package:eventapp/view/home/dashboard_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../componets/searchWidget.dart';
import '../../utills/appcolors.dart';

class FilterPage extends StatelessWidget {
  FilterPage({super.key});
  final FilterController filterController = Get.put(FilterController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                cursorColor: AppColors.whiteColor,
                onChanged: (value) => filterController.updateSearchQuery(value),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.whiteColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.whiteColor),
                  ),
                  prefixIcon: GestureDetector(
                    onTap: () {
                      Get.offAll(DashboardPage());
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      searchController.clear();
                      filterController.updateSearchQuery("");
                    },
                    child: Icon(
                      CupertinoIcons.xmark_circle_fill,
                      color: AppColors.lightGrey,
                      size: 20,
                    ),
                  ),
                  hintText: "Search by name, date, artist...",
                  hintStyle: TextStyle(
                    color: AppColors.lightGrey,
                    fontFamily: Assets.fontsPoppinsRegular,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: AppColors.greyColor,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children:
                        filterController.selectedFilters.keys.map((filterName) {
                      return FilterChip(
                        checkmarkColor: Colors.black,
                        label: Text(
                          filterName,
                          style: TextStyle(
                            color: filterController.selectedFilters[filterName]!
                                ? Colors.black
                                : AppColors.whiteColor,
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
                );
              }),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  bool noSearchQuery = searchController.text.isEmpty;
                  bool noFiltersSelected =
                      !filterController.selectedFilters.values.contains(true);

                  if (noSearchQuery && noFiltersSelected) {
                    return Text(
                      "Search or select a category to see events",
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontFamily: Assets.fontsPoppinsRegular),
                    );
                  }

                  if (filterController.filteredEvents.isEmpty) {

                    return Column(
                      children: [
                        Image.asset(
                          Assets.imagesEmptySearch,
                          height: 200,
                          width: 200,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextStyleHelper.CustomText(
                          text: "No events found!",
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: Assets.fontsPoppinsBold,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.greyColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: AppColors.whiteColor, width: 2)
                            ),

                          ),
                            onPressed: () {
                              searchController.clear();
                              filterController.updateSearchQuery("");

                              filterController.selectedFilters.keys.forEach((filterName) {
                                filterController.updateFilter(filterName, false);
                              });
                            },
                            child: TextStyleHelper.CustomText(
                              text: "Clear filters",
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              fontFamily: Assets.fontsPoppinsBold,
                            ),
                        )
                        // SizedBox(
                        //   width: 150,
                        //   child: CustomButton(
                        //       label: "Clear Filters",
                        //       onPressed: () {
                        //
                        //           searchController.clear();
                        //           filterController.updateSearchQuery("");
                        //
                        //           filterController.selectedFilters.keys.forEach((filterName) {
                        //             filterController.updateFilter(filterName, false);
                        //           });
                        //         },
                        //   ),
                        // )
                        // ElevatedButton(
                        //   onPressed: () {
                        //
                        //     searchController.clear();
                        //     filterController.updateSearchQuery("");
                        //
                        //     filterController.selectedFilters.keys.forEach((filterName) {
                        //       filterController.updateFilter(filterName, false);
                        //     });
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     primary: AppColors.greyColor,
                        //     onPrimary: AppColors.whiteColor,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //   ),
                        //   child: Text("Remove Filter"),
                        // ),
                      ],
                    );
                  }
                  return GridView.builder(
                    padding: EdgeInsets.all(0),
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
      ),
    );
  }
}
