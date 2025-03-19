import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../generated/assets.dart';

class OrgFeedbackController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxList<Map<String, dynamic>> feedbackList = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxString eventTitle = 'Event Feedback'.obs;

  Future<void> fetchFeedback(String eventId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get current organizer ID
      String? orgId = _auth.currentUser?.uid;
      if (orgId == null) {
        throw Exception("No authenticated user found");
      }

      print("Fetching feedback for eventId: $eventId, orgId: $orgId");

      // Access the correct path in Firestore based on your structure
      DocumentSnapshot orgDoc = await _firestore
          .collection('organizers')
          .doc(orgId)
          .get();

      if (!orgDoc.exists) {
        throw Exception("Organizer profile not found");
      }

      // Get the events map from the organizer document
      Map<String, dynamic> orgData = orgDoc.data() as Map<String, dynamic>;
      Map<String, dynamic>? events = orgData['events'] as Map<String, dynamic>?;

      if (events == null || !events.containsKey(eventId)) {
        throw Exception("Event not found or you don't have permission");
      }

      // Get the specific event
      Map<String, dynamic> eventData = events[eventId] as Map<String, dynamic>;

      // Store event title if available
      if (eventData.containsKey('title')) {
        eventTitle.value = eventData['title'] ?? 'Event Feedback';
      }

      // Get feedback array from the event
      List<dynamic>? feedbacks = eventData['feedback'] as List<dynamic>?;

      feedbackList.clear();

      if (feedbacks != null && feedbacks.isNotEmpty) {
        // Convert each feedback item to a Map
        for (var feedback in feedbacks) {
          feedbackList.add(feedback as Map<String, dynamic>);
        }
      }
    } catch (e) {
      print("Error fetching feedback: $e");
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Calculate average rating
  double get averageRating {
    if (feedbackList.isEmpty) return 0;

    double sum = 0;
    for (var feedback in feedbackList) {
      sum += (feedback['rating'] ?? 0).toDouble();
    }
    return sum / feedbackList.length;
  }
}

