import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Add this import

class StatisticsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable variables to hold statistics data
  final RxBool isLoading = true.obs;
  final RxDouble totalIncome = 0.0.obs;
  final RxInt totalSeats = 0.obs;
  final RxInt bookedSeats = 0.obs;
  final RxInt availableSeats = 0.obs;
  final RxMap<String, int> categoryWiseSeats = <String, int>{}.obs;
  final RxMap<String, int> categoryWiseBookedSeats = <String, int>{}.obs;

  // Method to fetch statistics for a specific event
  Future<void> fetchEventStatistics(int eventId) async {
    try {
      isLoading.value = true;

      // Query Firestore for the event with matching eventId
      QuerySnapshot querySnapshot = await _firestore
          .collection('eventDetails')
          .where('eventId', isEqualTo: eventId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No event found with ID: $eventId");
        isLoading.value = false;
        return;
      }

      // Get the first (and should be only) document
      DocumentSnapshot eventDoc = querySnapshot.docs.first;
      Map<String, dynamic> eventData = eventDoc.data() as Map<String, dynamic>;

      // Extract statistics data
      if (eventData.containsKey('statistics')) {
        Map<String, dynamic> stats = eventData['statistics'];

        // Update observable variables
        totalIncome.value = (stats['totalIncome'] ?? 0).toDouble();
        totalSeats.value = stats['totalSeats'] ?? 0;
        bookedSeats.value = stats['bookedSeats'] ?? 0;
        availableSeats.value = stats['availableSeats'] ?? 0;

        // Handle category-wise data
        if (stats.containsKey('categoryWiseSeats')) {
          Map<String, dynamic> catSeats = stats['categoryWiseSeats'];
          catSeats.forEach((key, value) {
            categoryWiseSeats[key] = value;
          });
        }

        if (stats.containsKey('categoryWiseBookedSeats')) {
          Map<String, dynamic> catBookedSeats = stats['categoryWiseBookedSeats'];
          catBookedSeats.forEach((key, value) {
            categoryWiseBookedSeats[key] = value;
          });
        }
      } else {
        print("No statistics data found for event with ID: $eventId");
      }
    } catch (e) {
      print("Error fetching event statistics: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Method to get category-wise booking percentages for chart
  List<BarChartGroupData> getCategoryBarData() {
    List<BarChartGroupData> barGroups = [];
    int index = 0;

    categoryWiseSeats.forEach((category, totalSeats) {
      int booked = categoryWiseBookedSeats[category] ?? 0;
      double percentage = totalSeats > 0 ? (booked / totalSeats) * 100 : 0;

      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: percentage,
              color: Colors.black,
              width: 16,
              borderRadius: BorderRadius.circular(4),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: 100, // 100%
                color: Colors.grey.withOpacity(0.3),
              ),
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      );

      index++;
    });

    return barGroups;
  }

  // Method to get category names for chart labels
  List<String> getCategoryNames() {
    return categoryWiseSeats.keys.toList();
  }
}