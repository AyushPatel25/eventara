import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/view/home/dashboard_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eventapp/generated/assets.dart';
import 'package:eventapp/utills/appcolors.dart';
import '../componets/button.dart';
import '../componets/text_style.dart';

class FeedBackController extends GetxController {
  var rating = 0.0.obs;
  var comment = ''.obs;
  TextEditingController textEditingController = TextEditingController();
  final String eventId;

  FeedBackController({required this.eventId});

  @override
  void onInit() {
    super.onInit();
    loadFeedback();
  }

  Future<void> saveFeedBack(double rate, String text) async {
    rating.value = rate;
    comment.value = text;
    textEditingController.text = text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('rating_$eventId', rate);
    await prefs.setString('comment_$eventId', text);
  }

  Future<void> loadFeedback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    rating.value = prefs.getDouble('rating_$eventId') ?? 0.0;
    comment.value = prefs.getString('comment_$eventId') ?? '';
    textEditingController.text = comment.value;
  }

  Future<String> getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userDoc['username'] ?? 'Unknown User';
    }
    return 'Unknown User';
  }

  Future<String?> getOrganizerId(String eventId) async {
    try {
      print("Searching for organizer of event: $eventId");

      // Look for the event in all organizers' collections
      QuerySnapshot organizersSnapshot = await FirebaseFirestore.instance
          .collection('organizers')
          .get();

      print("Found ${organizersSnapshot.docs.length} organizers to check");

      for (var organizerDoc in organizersSnapshot.docs) {
        print("Checking organizer: ${organizerDoc.id}");

        // Check if this organizer has the event
        QuerySnapshot eventSnapshot = await FirebaseFirestore.instance
            .collection('organizers')
            .doc(organizerDoc.id)
            .collection('eventDetails')
            .where('eventId', isEqualTo: eventId)
            .get();

        print("Found ${eventSnapshot.docs.length} matching events for this organizer");

        if (eventSnapshot.docs.isNotEmpty) {
          print("Found event with organizer: ${organizerDoc.id}");
          return organizerDoc.id;
        }
      }

      // If we didn't find it with the query above, try a direct document check
      print("Trying direct document lookup");

      // Try to check if the event exists directly as a document ID
      for (var organizerDoc in organizersSnapshot.docs) {
        DocumentSnapshot eventDoc = await FirebaseFirestore.instance
            .collection('organizers')
            .doc(organizerDoc.id)
            .collection('eventDetails')
            .doc(eventId)
            .get();

        if (eventDoc.exists) {
          print("Found event document with organizer: ${organizerDoc.id}");
          return organizerDoc.id;
        }
      }

      print("No organizer found for event: $eventId");
      return null;
    } catch (e) {
      print("Error fetching organizer ID: $e");
      return null;
    }
  }

  Future<void> submitFeedback() async {
    print("Submit feedback button clicked");
    print("Current rating: ${rating.value}");
    print("Current comment: ${textEditingController.text}");

    if (rating.value == 0.0) {
      Get.snackbar('Error', 'Please select a rating before submitting');
      return;
    }

    try {
      // Get current user
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        Get.snackbar('Error', 'You must be logged in to submit feedback');
        return;
      }

      String username = await getUsername();

      // Find the organizer that has this event
      QuerySnapshot organizersSnapshot = await FirebaseFirestore.instance
          .collection('organizers')
          .get();

      String? organizerId;

      // Loop through organizers to find the one containing this event
      for (var organizerDoc in organizersSnapshot.docs) {
        // Get the data
        Map<String, dynamic> organizerData = organizerDoc.data() as Map<String, dynamic>;

        // Check if this organizer has events
        if (organizerData.containsKey('events')) {
          Map<String, dynamic> events = organizerData['events'] as Map<String, dynamic>;

          // Check if this event exists in the events map
          if (events.containsKey(eventId)) {
            organizerId = organizerDoc.id;
            print("Found event $eventId in organizer $organizerId");
            break;
          }
        }
      }

      if (organizerId == null) {
        print("Could not find event $eventId in any organizer");
        Get.snackbar('Error', 'Could not find this event in the database');
        return;
      }

      // Create feedback data
      Map<String, dynamic> feedbackData = {
        'userId': currentUser.uid,
        'username': username,
        'rating': rating.value,
        'comment': textEditingController.text,
      };

      // Create the path for the feedback
      DocumentReference organizerRef = FirebaseFirestore.instance
          .collection('organizers')
          .doc(organizerId);

      // Add feedback to the event
      await organizerRef.update({
        'events.$eventId.feedback': FieldValue.arrayUnion([feedbackData])
      });

      print("Feedback saved successfully to organizer $organizerId for event $eventId");

      // Save locally
      await saveFeedBack(rating.value, textEditingController.text);

      // Show success dialog
      Get.dialog(
        Dialog(
          backgroundColor: AppColors.greyColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  Assets.imagesStarLottie,
                  width: 120,
                  height: 120,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 10),
                TextStyleHelper.CustomText(
                  text: "Submitted",
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  fontFamily: Assets.fontsPoppinsBold,
                ),
                const SizedBox(height: 5),
                TextStyleHelper.CustomText(
                  text: "Thanks for your feedback!",
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  fontFamily: Assets.fontsPoppinsBold,
                ),
                const SizedBox(height: 10),
                CustomButton(label: "OK", onPressed: () {
                  Navigator.pop(Get.overlayContext!);
                },),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      print("Submission error: $e");
      Get.snackbar('Error', 'Failed to submit feedback: $e');
    }
  }
}