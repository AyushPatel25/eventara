import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrgFeedbackController extends GetxController {
  final RxList<Map<String, dynamic>> feedbackList = RxList<Map<String, dynamic>>([]);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch feedback for a specific event
  Future<void> fetchFeedback(String eventId) async {
    try {
      // Query all organizers to find the one with the event
      QuerySnapshot organizersSnapshot = await _firestore.collection('organizers').get();

      for (var organizerDoc in organizersSnapshot.docs) {
        DocumentSnapshot eventDoc = await _firestore
            .collection('organizers')
            .doc(organizerDoc.id)
            .get();

        if (eventDoc.exists) {
          var data = eventDoc.data() as Map<String, dynamic>?;
          if (data != null && data.containsKey(eventId)) {
            var feedback = data[eventId]['feedback'] as Map<String, dynamic>?;
            if (feedback != null) {
              feedbackList.clear();
              feedbackList.add({
                'username': feedback['username'] ?? 'Unknown User',
                'rating': feedback['rating'] ?? 0.0,
                'comment': feedback['comment'] ?? 'No comment',
                'timestamp': feedback['timestamp']?.toDate().toString() ?? 'No timestamp',
              });
              break;
            }
          }
        }
      }
    } catch (e) {
      print("Error fetching feedback: $e");
      Get.snackbar("Error", "Failed to load feedback: $e", backgroundColor: Colors.red);
    }
  }
}