import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class OrganizerEventsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = true.obs;
  RxList upcomingEvents = [].obs;
  RxList pastEvents = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrganizerEvents();
  }

  Future<void> fetchOrganizerEvents() async {
    try {
      isLoading.value = true;

      // Clear existing data
      upcomingEvents.clear();
      pastEvents.clear();

      // Get current user ID
      String? orgId = _auth.currentUser?.uid;
      if (orgId == null) {
        throw Exception("No authenticated user found");
      }

      // Get organizer document
      DocumentSnapshot orgDoc = await _firestore.collection('organizers').doc(orgId).get();

      if (!orgDoc.exists) {
        isLoading.value = false;
        return;
      }

      Map<String, dynamic> orgData = orgDoc.data() as Map<String, dynamic>;
      Map<String, dynamic> events = orgData['events'] as Map<String, dynamic>? ?? {};

      DateTime today = DateTime.now();

      List<Future<void>> eventFutures = [];

      events.forEach((eventId, eventData) {
        Future<void> fetchEvent = _firestore
            .collection('eventDetails')
            .where('eventId', isEqualTo: int.parse(eventId))
            .get()
            .then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            Map<String, dynamic> eventDetails = querySnapshot.docs.first.data();

            DateTime? eventDate;
            try {
              eventDate = DateFormat('dd MMM yyyy').parse(eventDetails['eventDate']);
            } catch (e) {
              print("Error parsing date: ${eventDetails['eventDate']}");
            }

            if (eventDate != null) {
              if (eventDate.isAfter(today) || isSameDay(eventDate, today)) {
                upcomingEvents.add(eventDetails);
              } else {
                pastEvents.add(eventDetails);
              }
            }
          }
        });

        eventFutures.add(fetchEvent);
      });

      await Future.wait(eventFutures);

      upcomingEvents.sort((a, b) => _compareEventDates(a['eventDate'], b['eventDate']));
      pastEvents.sort((a, b) => _compareEventDates(b['eventDate'], a['eventDate'])); // Reverse order for past events

      isLoading.value = false;
    } catch (e) {
      print("Error fetching organizer events: $e");
      isLoading.value = false;
    }
  }

  int _compareEventDates(String dateA, String dateB) {
    try {
      DateTime a = DateFormat('dd MMM yyyy').parse(dateA);
      DateTime b = DateFormat('dd MMM yyyy').parse(dateB);
      return a.compareTo(b);
    } catch (e) {
      return 0;
    }
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void refreshEvents() {
    fetchOrganizerEvents();
  }
}