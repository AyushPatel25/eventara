import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/model/TicketCategory.dart';
import 'package:eventapp/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyTicketController extends GetxController {
  var categories = <TicketCategory>[].obs;

  var isLoading = true.obs;
  var event = Rxn<EventModel>();

  @override
  void onInit() {
    super.onInit();

    int? eventId = Get.arguments?['eventId'];
    if (eventId != null) {
      print(eventId);
      fetchEventDetails(eventId);
    } else {
      Get.snackbar("Error", "Event ID not found", );
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


        print("Ticket Categories Loaded: ${categories.value}");
      } else {
        print("No event found for eventId: $eventId");
        Get.snackbar("Error", "Event not found", backgroundColor: Colors.red);
      }
    } catch (e) {
      print("Error fetching event details: $e");
      Get.snackbar("Error", "Failed to load event", backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> purchase(int index) async {
    try {
      var category = categories[index];

      if (category.selectedTickets.value > 0 && category.availableSpots.value >= category.selectedTickets.value) {
        int newAvailable = category.availableSpots.value - category.selectedTickets.value;

        await FirebaseFirestore.instance
            .collection('eventDetails')
            .doc(event.value!.eventId.toString())
            .update({
          'ticketTypes.${category.name}.available': newAvailable,
        });


        categories[index].availableSpots.value = newAvailable;
        categories[index].selectedTickets.value = 0;

        Get.snackbar("Success", "Ticket purchased!", backgroundColor: Colors.green);
      } else {
        Get.snackbar("Error", "Not enough tickets available", backgroundColor: Colors.red);
      }
    } catch (e) {
      print("Error updating Firestore: $e");
      Get.snackbar("Error", "Purchase failed", backgroundColor: Colors.red);
    }
  }


  Future<void> buyTicket(String categoryName) async {
    try {
      if (!event.value!.ticketTypes.containsKey(categoryName)) {
        print("Ticket category not found");
        return;
      }

      TicketType selectedTicket = event.value!.ticketTypes[categoryName]!;

      if (selectedTicket.available <= 0) {
        Get.snackbar("Error", "No tickets available", backgroundColor: Colors.red);
        return;
      }

      int newAvailable = selectedTicket.available - 1;

      await FirebaseFirestore.instance
          .collection('eventDetails')
          .doc(event.value!.eventId.toString())
          .update({
        'ticketTypes.$categoryName.available': newAvailable,
      });

      event.update((val) {
        if (val != null) {
          val.ticketTypes[categoryName] = TicketType(
            available: newAvailable,
            price: selectedTicket.price,
          );
        }
      });

      fetchEventDetails(event.value!.eventId);

      Get.snackbar("Success", "Ticket purchased!", backgroundColor: Colors.green);
    } catch (e) {
      print("Error buying ticket: $e");
      Get.snackbar("Error", "Purchase failed", backgroundColor: Colors.red);
    }
  }




  void increment(int index) {
    if (categories[index].selectedTickets.value < categories[index].availableSpots.value) {
      categories[index].selectedTickets.value++;
    }
  }

  void decrement(int index) {
    if (categories[index].selectedTickets.value > 0) {
      categories[index].selectedTickets.value--;
    }
  }

}