import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/controller/feedback_cont.dart';
import 'package:eventapp/controller/org_feedback_cont.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventFeedbackPage extends StatelessWidget {
  final String eventId;

  EventFeedbackPage({super.key, required this.eventId});

  final OrgFeedbackController feedbackController = Get.put(OrgFeedbackController());

  @override
  Widget build(BuildContext context) {
    // Fetch feedback when the page loads
    feedbackController.fetchFeedback(eventId);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextStyleHelper.CustomText(
          text: "User Feedback",
          color: AppColors.whiteColor,
          fontWeight: FontWeight.w600,
          fontSize: 25,
          fontFamily: 'PoppinsBold',
        ),
      ),
      body: Obx(() {
        if (feedbackController.feedbackList.isEmpty) {
          return Center(
            child: TextStyleHelper.CustomText(
              text: "No feedback available",
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w400,
              fontSize: 16,
              fontFamily: 'PoppinsRegular',
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: feedbackController.feedbackList.length,
          itemBuilder: (context, index) {
            var feedback = feedbackController.feedbackList[index];
            return Card(
              color: AppColors.greyColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextStyleHelper.CustomText(
                      text: "User: ${feedback['username']}",
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'PoppinsBold',
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        TextStyleHelper.CustomText(
                          text: "Rating: ${feedback['rating']}/5",
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    TextStyleHelper.CustomText(
                      text: "Comment: ${feedback['comment']}",
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      fontFamily: 'PoppinsRegular',
                    ),
                    const SizedBox(height: 5),
                    TextStyleHelper.CustomText(
                      text: "Date: ${feedback['timestamp']}",
                      color: AppColors.lightGrey,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      fontFamily: 'PoppinsRegular',
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}