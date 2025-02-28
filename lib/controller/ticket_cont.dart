import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TicketController extends GetxController {
  var upcomingTickets = <Map<String, dynamic>>[].obs;
  var pastTickets = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUserTickets();
  }

  void fetchUserTickets() async {
    isLoading.value = true;
    upcomingTickets.clear();
    pastTickets.clear();

    User? user = _auth.currentUser;

    if (user == null) {
      print("User not logged in");
      isLoading.value = false;
      return;
    }

    String userId = user.uid;

    try {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        print("User document does not exist");
        isLoading.value = false;
        return;
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      if (!userData.containsKey('bookings') || userData['bookings'] == null) {
        print("No bookings found for user");
        isLoading.value = false;
        return;
      }

      List<dynamic> bookings = userData['bookings'];
      DateTime today = DateTime.now();

      List<Map<String, dynamic>> newUpcomingTickets = [];
      List<Map<String, dynamic>> newPastTickets = [];

      for (var bookingData in bookings) {
        Map<String, dynamic> ticket = Map<String, dynamic>.from(bookingData);
        _ensureTicketFields(ticket);
        DateTime expiryDate = _parseExpiryDate(ticket);

        if (expiryDate.isAfter(today)) {
          newUpcomingTickets.add(ticket);
        } else {
          newPastTickets.add(ticket);
        }
      }

      upcomingTickets.assignAll(newUpcomingTickets);
      pastTickets.assignAll(newPastTickets);

      print("Loaded ${upcomingTickets.length} upcoming tickets");
    } catch (e) {
      print("Error fetching tickets: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _ensureTicketFields(Map<String, dynamic> ticket) {
    ticket['eventName'] = ticket['eventName'] ?? ticket['name'] ?? 'Unknown Event';
    ticket['location'] = ticket['location'] ?? ticket['venue'] ?? 'Unknown Location';
    ticket['date'] = ticket['date'] ?? _formatDateFromTimestamp(ticket['eventDate']);
    ticket['time'] = ticket['time'] ?? '00:00';
    ticket['seatNo'] = ticket['seatNo'] ?? ticket['seat'] ?? 'Standing';
  }

  String _formatDateFromTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return DateFormat('dd MMM yyyy').format(timestamp.toDate());
    }
    return 'N/A';
  }

  DateTime _parseExpiryDate(Map<String, dynamic> ticket) {
    if (ticket['expiryDate'] is Timestamp) {
      return (ticket['expiryDate'] as Timestamp).toDate();
    }
    return DateTime.now().add(Duration(days: 1));
  }

  void refreshTickets() {
    fetchUserTickets();
  }
}
