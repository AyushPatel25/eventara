import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/model/TicketCategory.dart';
import 'package:eventapp/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/home/eticket.dart';

class BuyTicketController extends GetxController {
  var categories = <TicketCategory>[].obs;
  var isLoading = true.obs;
  var event = Rxn<EventModel>();
  var selectedCategoryIndex = RxnInt(); // Stores the selected category index
  var totalSelectedTickets = 0.obs; // Track total selected tickets

  @override
  void onInit() {
    super.onInit();
    int? eventId = Get.arguments?['eventId'];
    if (eventId != null) {
      fetchEventDetails(eventId);
    } else {
      Get.snackbar("Error", "Event ID not found");
    }
  }

  Future<void> fetchEventDetails(int eventId) async {
    try {
      isLoading.value = true;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('eventDetails')
          .where('eventId', isEqualTo: eventId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        event.value = EventModel.fromJson(data);

        categories.value = event.value!.ticketTypes.entries.map((entry) {
          return TicketCategory(
            name: entry.key,
            price: entry.value.price,
            spots: entry.value.available,
          );
        }).toList()
          ..sort((a, b) => b.price.compareTo(a.price));

        selectedCategoryIndex.value = null;
        totalSelectedTickets.value = 0;
      } else {
        Get.snackbar("Error", "Event not found", backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load event", backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void increment(int index) {
    if (selectedCategoryIndex.value == null || selectedCategoryIndex.value == index) {
      if (totalSelectedTickets.value < 10 && categories[index].selectedTickets.value < categories[index].availableSpots.value) {
        categories[index].selectedTickets.value++;
        totalSelectedTickets.value++;
        selectedCategoryIndex.value = index;
      }
    } else {
      Get.snackbar("Error", "You can only select tickets from one category at a time.", backgroundColor: Colors.red);
    }
  }

  void decrement(int index) {
    if (categories[index].selectedTickets.value > 0) {
      categories[index].selectedTickets.value--;
      totalSelectedTickets.value--;

      if (categories[index].selectedTickets.value == 0) {
        selectedCategoryIndex.value = null; // Reset category selection when no tickets are selected
      }
    }
  }

  Future<void> purchase() async {
    if (selectedCategoryIndex.value == null || totalSelectedTickets.value == 0) {
      Get.snackbar("Error", "Please select at least one ticket", backgroundColor: Colors.red);
      return;
    }

    int index = selectedCategoryIndex.value!;
    var category = categories[index];

    try {
      if (category.availableSpots.value >= category.selectedTickets.value) {
        int newAvailable = category.availableSpots.value - category.selectedTickets.value;

        await FirebaseFirestore.instance
            .collection('eventDetails')
            .doc(event.value!.eventId.toString())
            .update({
          'ticketTypes.${category.name}.available': newAvailable,
        });

        categories[index].availableSpots.value = newAvailable;
        categories[index].selectedTickets.value = 0;
        totalSelectedTickets.value = 0;
        selectedCategoryIndex.value = null;

        // Navigate to eTicket page with event details
        Get.to(() => Eticket(), arguments: {
          'eventImage': event.value!.eventImage,
          'eventName': event.value!.title,
          'eventLocation': event.value!.location,
          'eventDate': event.value!.eventDate,
          'ticketCategory': category.name,
          'ticketPrice': category.price,
          'ticketCount': totalSelectedTickets.value,
        });

        Get.snackbar("Success", "Tickets purchased successfully!", backgroundColor: Colors.green);
      } else {
        Get.snackbar("Error", "Not enough tickets available", backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("Error", "Purchase failed", backgroundColor: Colors.red);
    }
  }
}
