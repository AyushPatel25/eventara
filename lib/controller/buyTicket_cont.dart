import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/model/TicketCategory.dart';
import 'package:eventapp/model/event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/home/eticket.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class BuyTicketController extends GetxController {
  var categories = <TicketCategory>[].obs;
  final isLoading = true.obs;
  var event = Rxn<EventModel>();
  var selectedCategoryIndex = RxnInt();
  var totalSelectedTickets = 0.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var newAvitic = 0.obs;

  late Razorpay _razorpay;

  bool get isButtonEnabled =>
      selectedCategoryIndex.value != null &&
          totalSelectedTickets.value > 0;

  @override
  void onInit() {
    super.onInit();
    int? eventId = Get.arguments?['eventId'];
    if (eventId != null) {
      fetchEventDetails(eventId);
    } else {
      Get.snackbar("Error", "Event ID not found");
    }

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout() {
    if (selectedCategoryIndex.value == null || totalSelectedTickets.value == 0) {
      Get.snackbar("Error", "No tickets selected", backgroundColor: Colors.red);
      return;
    }

    var options = {
      'key': 'rzp_test_af0CuAn19pEBjw',
      'amount': (categories[selectedCategoryIndex.value!].price * totalSelectedTickets.value) * 100,
      'name': 'eventara',
      'timeout': 120,
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment Successful! Payment ID: ${response.paymentId}");

    if (selectedCategoryIndex.value == null || totalSelectedTickets.value == 0) {
      Get.snackbar("Error", "No tickets selected", backgroundColor: Colors.red);
      return;
    }

    isLoading.value = true;

    int index = selectedCategoryIndex.value!;
    var category = categories[index];
    int newAvailable = category.availableSpots.value - totalSelectedTickets.value;
    List<String> ticketNumbers = [];

    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final querySnapshot = await _firestore
          .collection('eventDetails')
          .where('eventId', isEqualTo: event.value?.eventId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        Get.snackbar("Error", "Event not found", backgroundColor: Colors.red);
        return;
      }

      final docRef = querySnapshot.docs.first.reference;

      await _firestore.runTransaction<void>(((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          throw Exception('Event does not exist!');
        }

        // Get current ticket data
        final currentAvailable = snapshot.get('ticketTypes.${category.name.toLowerCase()}.available') as int;

        // Get current statistics
        Map<String, dynamic> statistics = snapshot.get('statistics') ?? {
          'availableSeats': 0,
          'bookedSeats': 0,
          'categoryWiseBookedSeats': {},
          'categoryWiseSeats': {},
          'totalIncome': 0
        };

        // Calculate new statistics
        int availableSeats = statistics['availableSeats'] ?? 0;
        int bookedSeats = statistics['bookedSeats'] ?? 0;
        Map<String, dynamic> categoryWiseBookedSeats = statistics['categoryWiseBookedSeats'] ?? {};
        int totalIncome = statistics['totalIncome'] ?? 0;

        // Update statistics
        availableSeats -= totalSelectedTickets.value;
        bookedSeats += totalSelectedTickets.value;

        // Update category-wise booked seats
        String categoryName = category.name;
        categoryWiseBookedSeats[categoryName] = (categoryWiseBookedSeats[categoryName] ?? 0) + totalSelectedTickets.value;

        // Update total income
        totalIncome += category.price * totalSelectedTickets.value;

        if (currentAvailable < totalSelectedTickets.value) {
          throw Exception('Not enough tickets available!');
        }

        // Generate ticket numbers
        for (int i = 0; i < totalSelectedTickets.value; i++) {
          String categoryPrefix = category.name[0].toUpperCase();
          int ticketNum = currentAvailable - i;
          ticketNumbers.add('$categoryPrefix$ticketNum');
        }

        // Update both ticket type availability and statistics
        transaction.update(docRef, {
          'ticketTypes.${category.name.toLowerCase()}.available': newAvailable,
          'statistics.availableSeats': availableSeats,
          'statistics.bookedSeats': bookedSeats,
          'statistics.categoryWiseBookedSeats.${category.name}': categoryWiseBookedSeats[category.name],
          'statistics.totalIncome': totalIncome
        });

        // Rest of the booking process remains the same
        final eventBookingRef = _firestore
            .collection('eventBookings')
            .doc(event.value?.eventId.toString());

        final userRef = _firestore.collection('users').doc(currentUser.uid);

        final bookingData = {
          'paymentId': response.paymentId,
          'userId': currentUser.uid,
          'userName': currentUser.displayName ?? '',
          'userEmail': currentUser.email ?? '',
          'bookingDate': DateTime.now(),
          'ticketDetails': {
            'category': category.name,
            'price': category.price,
            'quantity': totalSelectedTickets.value,
            'ticketNumbers': ticketNumbers,
          },
          'status': 'confirmed',
          'totalAmount': category.price * totalSelectedTickets.value,
        };

        final bookedTicket = {
          'paymentId': response.paymentId,
          'eventId': event.value?.eventId,
          'eventName': event.value?.title,
          'eventLocation': event.value!.location,
          'eventImage': event.value!.eventImage,
          'ticketCount': totalSelectedTickets.value,
          'eventDate': event.value?.eventDate,
          'expiryDate': event.value?.expiryDate,
          'ticketCategory': category.name,
          'ticketPrice': category.price,
          'eventTime': event.value!.time,
          'arrangement': event.value!.arrangement,
          'ticketNumbers': ticketNumbers,
          'bookingDate': DateTime.now(),
          'status': 'confirmed',
          'totalAmount': category.price * totalSelectedTickets.value,
        };

        transaction.set(eventBookingRef, bookingData);
        transaction.set(userRef, {
          'bookings': FieldValue.arrayUnion([bookedTicket])
        }, SetOptions(merge: true));
      }));

      Get.offAll(() => Eticket(), arguments: {
        'eventImage': event.value!.eventImage,
        'eventName': event.value!.title,
        'eventLocation': event.value!.location,
        'eventDate': event.value!.eventDate,
        'ticketCategory': category.name,
        'ticketPrice': category.price,
        'ticketCount': totalSelectedTickets.value,
        'eventTime': event.value!.time,
        'arrangement': event.value!.arrangement,
        'ticketNumbers': ticketNumbers,
        'fromBookTicket': true,
      });

      Get.snackbar("Success", "Tickets booked successfully!", backgroundColor: Colors.green);

    } catch (e) {
      print('Error processing booking: $e');
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment failed: ${response.code} - ${response.message}");
    Get.snackbar("Error", "Payment Failed! Error: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("Wallet", "External Wallet Used: ${response.walletName}");
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
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
      print("Error fetching event details: $e");
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
      } else if (totalSelectedTickets.value >= 10) {
        Get.snackbar("Limit Reached", "You can only purchase up to 10 tickets at once", backgroundColor: Colors.orange);
      } else if (categories[index].selectedTickets.value >= categories[index].availableSpots.value) {
        Get.snackbar("Sold Out", "No more tickets available in this category", backgroundColor: Colors.orange);
      }
    } else {
      Get.snackbar("Error", "You can only select tickets from one category at a time", backgroundColor: Colors.red);
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

    // Open the Razorpay checkout
    openCheckout();
  }
}