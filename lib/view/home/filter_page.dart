import 'package:eventapp/controller/filter_cont.dart';
import 'package:eventapp/view/home/dashboard_page.dart';
import 'package:eventapp/view/home/event_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utills/appcolors.dart';

class FilterPage extends StatelessWidget {
  FilterPage({super.key});
  final FilterController homeController = Get.put(FilterController());

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
                return ListView.builder(
                  itemCount: homeController.filteredEvents.length,
                  itemBuilder: (context, index) {
                    var event = homeController.filteredEvents[index];


                    String artistName = event['artists']?.isNotEmpty == true
                        ? event['artists'][0]['artistName']
                        : 'Unknown Artist';

                    String eventDate = event['eventDate'] ?? 'Unknown Date';

                    return GestureDetector(
                      onTap: () {
                        print("Opening Event Details for eventId: ${event['eventId']}");
                        Get.to(() => EventDetails(), arguments: {'eventId': event['eventId']});
                      },
                      child: Card(
                        color: AppColors.greyColor,
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: event['eventImage'] != null
                              ? Image.network(event['eventImage'], width: 50, height: 50, fit: BoxFit.contain)
                              : Icon(Icons.image, color: Colors.white),
                          title: Text(
                            event['title'] ?? "Unknown Title",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "$eventDate | $artistName",
                            style: TextStyle(color: Colors.grey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
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
