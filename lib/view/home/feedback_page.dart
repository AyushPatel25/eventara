import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore package
import 'package:firebase_auth/firebase_auth.dart'; // Add Firebase Auth package
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:eventapp/componets/button.dart';
import 'package:eventapp/componets/snack_bar.dart';
import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/controller/feedback_cont.dart';
import 'package:eventapp/generated/assets.dart';
import 'package:eventapp/utills/appcolors.dart';

class FeedbackPage extends StatelessWidget {
  final String eventId; // Add eventId parameter
  FeedbackPage({super.key, required this.eventId});

  final FeedBackController feedBackController = Get.put(FeedBackController());

  // Fetch the current user's username from Firestore
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

  // Fetch the organizer ID dynamically using the eventId
  Future<String?> getOrganizerId(String eventId) async {
    try {
      // Query the eventDetails subcollection under all organizers
      QuerySnapshot organizersSnapshot =
      await FirebaseFirestore.instance.collection('organizers').get();

      for (var organizerDoc in organizersSnapshot.docs) {
        QuerySnapshot eventDetailsSnapshot = await FirebaseFirestore.instance
            .collection('organizers')
            .doc(organizerDoc.id)
            .collection('eventDetails')
            .where('eventId', isEqualTo: eventId)
            .limit(1)
            .get();

        if (eventDetailsSnapshot.docs.isNotEmpty) {
          return organizerDoc.id; // Return the organizer ID
        }
      }
      return null; // Return null if no organizer is found
    } catch (e) {
      print("Error fetching organizer ID: $e");
      return null;
    }
  }

  void submitFeedback() async {
    // Save feedback locally
    feedBackController.saveFeedBack(
        feedBackController.rating.value, feedBackController.textEditingController.text);

    // Get the username
    String username = await getUsername();

    // Get the organizer ID dynamically
    String? organizerId = await getOrganizerId(eventId);

    if (organizerId == null) {
      // Show error if organizer ID is not found
      // Get.showSnackbar(
      //   customSnackBar(
      //     message: "Failed to submit feedback: Organizer not found for this event.",
      //     color: Colors.red,
      //   ),
      // );
      return;
    }

    // Save feedback to Firestore with nested structure
    try {
      await FirebaseFirestore.instance
          .collection('organizers')
          .doc(organizerId) // Dynamic organizer ID
          .set({
        eventId: { // Use eventId as a field with feedback map
          'feedback': {
            'username': username,
            'rating': feedBackController.rating.value,
            'comment': feedBackController.textEditingController.text,
            'timestamp': FieldValue.serverTimestamp(),
          }
        }
      }, SetOptions(merge: true)); // Use merge to avoid overwriting other data

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
                    fontFamily: Assets.fontsPoppinsBold),
                const SizedBox(height: 5),
                TextStyleHelper.CustomText(
                    text: "Thanks for your feedback!",
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontFamily: Assets.fontsPoppinsBold),
                const SizedBox(height: 10),
                CustomButton(label: "OK", onPressed: () {
                  Get.back();
                }),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      // Show error snackbar if something goes wrong
      // Get.showSnackbar(
      //
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: TextStyleHelper.CustomText(
              text: "Feedback",
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
              fontSize: 25,
              fontFamily: Assets.fontsPoppinsBold),
        ),
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.greyColor,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image(
                        image: AssetImage(Assets.imagesPoster),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextStyleHelper.CustomText(
                      text: "What is your rating?",
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      fontFamily: Assets.fontsPoppinsBold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                        () => RatingBar.builder(
                      itemPadding: const EdgeInsets.symmetric(horizontal: 5),
                      direction: Axis.horizontal,
                      minRating: 1,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber.withOpacity(0.8),
                      ),
                      onRatingUpdate: (value) {
                        feedBackController.rating.value = value;
                      },
                      initialRating: feedBackController.rating.value,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextStyleHelper.CustomText(
                    text: "Please share your opinion",
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    fontFamily: Assets.fontsPoppinsBold,
                  ),
                  TextStyleHelper.CustomText(
                    text: "about the event",
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    fontFamily: Assets.fontsPoppinsBold,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: feedBackController.textEditingController,
                    cursorColor: AppColors.whiteColor,
                    maxLines: 4,
                    minLines: 3,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.lightGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.lightGrey),
                      ),
                      hintText: "Write your feedback",
                      hintStyle: TextStyle(
                          color: AppColors.lightGrey, fontFamily: 'regular'),
                      filled: true,
                      fillColor: AppColors.greyColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.lightGrey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    label: "Send feedback",
                    onPressed: () {
                      submitFeedback();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}